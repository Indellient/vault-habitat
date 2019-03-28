package io.chef.nationalparks.mongo;

import java.util.Arrays;

import com.mongodb.MongoClient;
import com.mongodb.ServerAddress;
import com.mongodb.MongoCredential;

import com.mongodb.client.MongoDatabase;

public class DBConnection
{

    private MongoDatabase mongoDB;
    private static DBConnection instance = null;

    public static synchronized MongoDatabase getDB()
    {
        if (instance == null)
        {
            instance = new DBConnection();
        }
        return instance.mongoDB;
    }

    private DBConnection()
    {
        String mongoHost = System.getProperty("MONGODB_SERVICE_HOST");
        if (mongoHost == null)
        {
            mongoHost = "127.0.0.1";
        }

        String mongoPort = System.getProperty("MONGODB_SERVICE_PORT");
        if (mongoPort == null)
        {
            mongoPort = "27017";
        }

        String mongoDBName = System.getProperty("MONGODB_DATABASE");
        if (mongoDBName == null)
        {
            mongoDBName = "demo";
        }

        String mongoUsername = System.getProperty("MONGODB_USERNAME");
        String mongoPassword = System.getProperty("MONGODB_PASSWORD");

        System.out.printf("Attempting connection to database at mongodb://%s:%s/%s", mongoHost, mongoPort, mongoDBName);

        ServerAddress addr = new ServerAddress(mongoHost, Integer.decode(mongoPort));
        MongoCredential credential = MongoCredential.createCredential(mongoUsername,
                                                                      mongoDBName,
                                                                      mongoPassword.toCharArray());

        MongoClient mongo = new MongoClient(addr, Arrays.asList(credential));
        System.out.println("Connected to database");

        mongoDB = mongo.getDatabase(mongoDBName);
    }
}
