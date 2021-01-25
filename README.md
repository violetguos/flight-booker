# Flight booker

- project from Odin to practise building nested forms

## Functionalities

- Enter desired dates / airports and click “Search”
- Choose from among a list of eligible flights
- Enter passenger information for all passengers
- Enter billing information

## Lessons learned

### Nested form

In order to submit `passenger` under `booking`, we need to prepare the `#new` of `Booking` to be ready to create passengers.

```
    @booking.flight = Flight.find(params[:booking][:flight_id])
    @booking.passengers.build # <--- I missed this! Took me forever to figure out!!
```

## Future

- Obfuscate the web query URL. I can't figure out how to render a query `/flights?flight[from_airport_id]=8` as `//flights?flight[from_airport]=SFO`. It can't be good to expose your internal DB setup.
