# README

# subscribe_api #
This is a Ruby API to solve Code Challenge to [Subscribe](https://subscribeplatform.com/)

[Requirements](https://gist.github.com/safplatform/792314da6b54346594432f30d5868f36)
### Assumptions
1. In Output 3 in the Requirements I believe that have an error. Says `3 imported box of chocolates: 35.55`. I believe that the round up to the nearest 0.05 is wrong.  The rounding rules for sales tax are that for a tax rate of n%, a shelf price of p contains (np/100 rounded up to the nearest 0.05) amount of sales tax:
```
n = 5
p = 11.25
tax = (5*11.25/100)
tax = 0.5625
# round up the tax to the nearest 0.05 = 0.55
tax = 0.55
price = ( 11.25 + 0.55) * 3
price = 35.40
# In the Requirements says 35.55
```
## Deployment
### Install
- Ruby
```sh
rvm install ruby
```
- Clone this repo:
```sh
git clone git@github.com:joseasantacruz/subscribe_api.git
```
- bundle install
```sh
cd api_subscribe
bundle install
```
### Run server
```sh
rackup
```  