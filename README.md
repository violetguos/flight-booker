# Flight booker

- project from Odin to practice building nested forms

## Functionalities

- Enter desired dates / airports and click “Search”
- Choose from among a list of eligible flights
- Enter passenger information for all passengers
- Enter billing information

## Extra flair: Stripe

I integrated a dummy Stripe payment processor. Since I don't have a private API key, the payment never really goes through, and no transactions ever happen.

However, Stripe's latest documentation isn't very rails-friendly. It's mostly handled in JavaScript. I created a `Charge` model, which has one `Booking`.

In the [previous edition](https://stripe.com/docs/legacy-checkout/rails), Stripe decides to have a stand along HTML webpage in the checkout stage. Everything (e.g. styling) no longer applies if you follow their set up. I went into `app/views/layouts/charges.html.erb` and changed the meta tags. I also got rid of their old Javascript event listener after clicking on submit payment. Instead, it redirects locally.

## Lessons learned

### Multiple foreign key dependencies

`->` indicates `belongs_to`:

flight & passenger -> booking -> Stripe charge

I learned to use hidden field, permitting foreign attributes and passing arguments into other controllers' actions and views.

### Nested form

In order to submit `passenger` under `booking`, we need to prepare the `#new` of `Booking` to be ready to create passengers.

```
    @booking.flight = Flight.find(params[:booking][:flight_id])
    @booking.passengers.build # <--- I missed this! Took me forever to figure out!!
```

### DateTime, Date, Time

1. storage
   I initially decided to store to separate columns in `Flight` instead of just `DateTime`. Then, in order to generate more flights in `db:seed` with `Faker`, it's impossible to store them separately.

I merged then, and re-migrated my databases.

2. Query

The user only selects available dates, not the exact departure time down to minutes. This form then only sends the date portion of the `DateTime` object to the active record query.

I had a very hacky line for this.
`flights = Flight.where('takeoff <= ? and takeoff >= ?', search[:takeoff] + ' 23:59:59 +0000',search[:takeoff] + ' 00:00:00 +0000')`

I know, it's terrible... I manually concatenated a string to query for anything from 00:00:00 to 23:59:59 on a given day. This is hard to read, and extremely prone to typos and bugs. I turned to Odin's community for help, and now I'm using `Flight.where(takeoff: Date.parse(search[:takeoff]).all_day)`.

### Webpack for front end

Previously, I installed `Bulma` from rails gem. Following the latest trend of JS controlled front end, I tried to use `yarn` instead of `gem` to install Bulma. This also means that I'm applying `webpack` instead of Rails' asset pipeline.

My notes on webpack [here](https://github.com/violetguos/ror-practice/blob/master/ror-notes/webpack.md)

## Future

- Obfuscate the web query URL. I can't figure out how to render a query `/flights?flight[from_airport_id]=8` as `//flights?flight[from_airport]=SFO`. It can't be good to expose your internal DB setup.

## Upgrade - session vs hidden field

### 1. **Set Session (When User Selects Flight)**

```ruby
# controllers/flight_selection_controller.rb
def select_flight
  @flight = Flight.find_by(id: params[:flight_id])
  
  # Validate flight exists (from seeded DB)
  unless @flight
    redirect_to flights_path, alert: "Invalid flight selected"
    return
  end
  
  # Store in session
  session[:flight_id] = @flight.id
  session[:flight_selected_at] = Time.current  # Optional: track timing
  
  redirect_to booking_form_path
end
```

### 2. **Access Session (In Booking Form Controller)**

```ruby
# controllers/bookings_controller.rb
def new
  # Validate session has flight_id
  validate_flight_session!
  
  @flight = Flight.find(session[:flight_id])
  @booking = Booking.new
end

def create
  validate_flight_session!
  
  @booking = Booking.new(booking_params.merge(flight_id: session[:flight_id]))
  
  if @booking.save
    clear_flight_session  # Clear after successful booking
    redirect_to @booking, notice: "Booking confirmed!"
  else
    render :new
  end
end

private

def booking_params
  params.require(:booking).permit(:passenger_name, :seat_preference, :other_attribute...)
  # Note: DON'T permit :flight_id - it comes from session
end
```

### 3. **Validation Helper (Crucial Security)**

```ruby
# Add to bookings_controller.rb (or concerns)
private

def validate_flight_session!
  unless session[:flight_id]
    redirect_to flights_path, alert: "Please select a flight first"
    return false
  end
  
  unless Flight.exists?(session[:flight_id])
    clear_flight_session
    redirect_to flights_path, alert: "Flight no longer available"
    return false
  end
  
  true
end

def clear_flight_session
  session[:flight_id] = nil
  session[:flight_selected_at] = nil
end
```

### 4. **Form View (Using Session)**

```erb
# views/bookings/new.html.erb
<%= form_with(model: @booking) do |f| %>
  <!-- Hidden field from session (optional - can also pass in controller) -->
  <%= f.hidden_field :flight_id, value: session[:flight_id] %>
  
  <!-- Other booking fields -->
  <%= f.label :passenger_name %>
  <%= f.text_field :passenger_name %>
  
  <%= f.submit "Book Flight" %>
<% end %>

<!-- Show user what flight they selected -->
<p>Flight: <%= @flight.number %> to <%= @flight.destination %></p>
```

### 5. **Clear Session on Logout (Security)**

```ruby
# controllers/users/sessions_controller.rb
def destroy
  # Clear all booking-related session data
  session[:flight_id] = nil
  session[:flight_selected_at] = nil
  
  # Standard logout
  reset_session
  redirect_to root_path, notice: "Logged out successfully"
end
```

### 6. **Optional: Session Timeout**

```ruby
# Add to validate_flight_session! if you want expiration
def validate_flight_session!
  unless session[:flight_id]
    redirect_to flights_path, alert: "Please select a flight first"
    return false
  end
  
  # Expire session after 15 minutes (optional)
  if session[:flight_selected_at] && 
     (Time.current - session[:flight_selected_at]) > 15.minutes
    clear_flight_session
    redirect_to flights_path, alert: "Flight selection expired. Please select again."
    return false
  end
  
  unless Flight.exists?(session[:flight_id])
    clear_flight_session
    redirect_to flights_path, alert: "Flight no longer available"
    return false
  end
  
  true
end
```

### Key Security Points

| Crucial Practice | Why |
|-----------------|-----|
| **Validate flight exists** | Prevents using stale/invalid session IDs |
| **Don't permit `:flight_id`** | Force it from session, not user params [1] |
| **Clear session after use** | Prevents reuse of old session data |
| **Clear on logout** | Security cleanup |
| **Optional timeout** | Prevents abandoned sessions |

This pattern ensures `flight_id` comes **only from your seeded DB** via session, not from user-modifiable form data.

Sources
[1] How to correctly pass through foreign keys in Rails form_for https://stackoverflow.com/questions/27792256/how-to-correctly-pass-through-foreign-keys-in-rails-form-for
