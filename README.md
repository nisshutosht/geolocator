## How to consume the Application's API

### Summary:
This application contains of 3 main APIs, Creation of Geolocation record, Deletion of Geolocation record and Retrieval of Geolocation record
* Create: `POST` `/api/v1/geolocations`, in which you can pass either `url` or `ip_address` as a parameter.
  * `ip_address`: pass `ip_address` parameter key and value should be a valid public IPv4 or IPv6 address
  * `url`: pass `url` parameter key and value to be a valid `http` or an `https` url, which should be publicly acessible.
* Read/Show: `GET` `/api/v1/geolocations/:id`, you can retrieve based on ID which you would have got from creation of the geolocation record, or URL or ip_address passed during creation of the record
  * `id`: For this simply pass the ID of the record(must be ain integer) into the URL, eg. if id is 10 then the URL becomes `/api/v1/geolocations/10`.
  * `url`: For this simply pass the `url` as the id, and another parameter key url and value should be the valid URL passed at the time of creation of the record, eg. `/api/v1/geolocations/url?url=https://google.com`
  * `ip_address`: For this simply pass the `ip_address` as the id, and another parameter key ip_address and value should be the valid ip_address passed at the time of creation of the record, eg. `/api/v1/geolocations/ip_address?ip_address=119.11.12.20`
* Delete: `DELETE` `/api/v1/geolocations/:id`, you can delete based on ID which you would have got from creation of the geolocation record, or URL or ip_address passed during creation of the record
  * `id`: For this simply pass the ID of the record(must be ain integer) into the URL, eg. if id is 10 then the URL becomes `/api/v1/geolocations/10`.
  * `url`: For this simply pass the `url` as the id, and another parameter key url and value should be the valid URL passed at the time of creation of the record, eg. `/api/v1/geolocations/url?url=https://google.com`
  * `ip_address`: For this simply pass the `ip_address` as the id, and another parameter key ip_address and value should be the valid ip_address passed at the time of creation of the record, eg. `/api/v1/geolocations/ip_address?ip_address=119.11.12.20`

What is done:
* Created a Library for consuming Ipstack API
* Wrote rspec test cases for controller, model, service.
* Read/Write/Delete of Geolocations

What is not done:
* Rspec test cases for the Ipstack API consumer library client.
* I18n/Internationalization, still.
* Testing with all error codes. For this I have relied upon the structure of the API response, but I am not sure if the API will behave consistently same for all response codes. Good to test, but could not find
  anywhere in documentation for any test IP inputs to recieve any target error codes(like recurly/stripe provide specific card numbers to invoke specific error cases).
* Should have created VCR recordings instead of webmock static response codes, which is near to the actual response, but not actual.
* Rails in docker compose file, I usually on my local use Redis, Database, etc in docker compose, but never rails application, wanted to provide true picture about how I work.

## Instructions to start the application
* This application uses dotenv gem for all environments, you can simply copy env.example file to `.env` and add real values to the keys which are already put in there.
* (assuming docker is installed and running), run `docker compose up` which should get the database setup and running.
* For the first time only, run `rails db:create db:migrate`
* and finally `rails server` OR `rails s` simply. This should get the app running on `http://localhost:3000` or `http://127.0.0.1:3000`
