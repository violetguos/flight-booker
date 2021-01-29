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
