# National Parks

## Build the application (macOS)

Install Maven. I am assuming that Java is already installed with these tools.

```
$ brew install maven
```

## Run the application (macOS)

Install Tomcat.

```
$ brew install tomcat
```

Copy the built war into Tomcat's webapps directory.

```
$ cp target/national-parks.war $(catalina -h | grep CATALINA_HOME | cut -d ' ' -f 5)/webapps
$ catalina run
```

Visit http://localhost:8080/national-parks

## Start the database (macOS)

```
$ brew install mongodb
$ brew services start mongodb
```

## Populate the database

Add all the national parks data to the MongoDB database.

```
$ mongoimport --drop -d demo -c nationalparks --type json --jsonArray --file ./national-parks.json $*
```
