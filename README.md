# Build

* Install plugin-in defined in Gemfile

```
bundle install
```

* Migrate columns to Database

```
rake db:migrate
```

* Execute Send Email Active Job in other process

```
rake jobs:work
```

* Execute rails server

```
rails s
```

* Launch browser to link `localhost:3000`
