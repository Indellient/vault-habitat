package io.chef.nationalparks.mongo;

import java.util.Arrays;
import java.util.Map;

import com.bettercloud.vault.Vault;
import com.bettercloud.vault.VaultConfig;
import com.bettercloud.vault.VaultException;
import com.bettercloud.vault.response.AuthResponse;

import com.mongodb.MongoClient;
import com.mongodb.ServerAddress;
import com.mongodb.MongoCredential;

import com.mongodb.client.MongoDatabase;

public class DBConnection
{

    private MongoDatabase mongoDB;
    private static DBConnection instance = null;

    private Vault vault;

    public static synchronized MongoDatabase getDB()
    {
        if (instance == null)
        {
            try {
                instance = new DBConnection();
            } catch (VaultException e) {
                System.out.println("Exception! " + e.getStackTrace());
                System.out.println("Exception message: " + e.getMessage());
                System.out.println("Exception status code: " + e.getHttpStatusCode());
            }
        }
        return instance.mongoDB;
    }

    private DBConnection() throws VaultException
    {
        if (vault == null) {
            getVault();
        }

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

        String mongoVaultRole = System.getProperty("MONGODB_VAULT_ROLE");
        Map<String, String> data = vault.logical()
                                        .read("database/creds/" + mongoVaultRole)
                                        .getData();

        System.out.println("Data: ");
        System.out.println(data);
        String mongoUsername = data.get("username");
        String mongoPassword = data.get("password");

        System.out.printf("Attempting connection to database at mongodb://%s:%s/%s", mongoHost, mongoPort, mongoDBName);

        ServerAddress addr = new ServerAddress(mongoHost, Integer.decode(mongoPort));
        MongoCredential credential = MongoCredential.createCredential(mongoUsername,
                                                                      mongoDBName,
                                                                      mongoPassword.toCharArray());

        MongoClient mongo = new MongoClient(addr, Arrays.asList(credential));
        System.out.println("Connected to database");

        mongoDB = mongo.getDatabase(mongoDBName);
    }

    private void getVault() throws VaultException {
        VaultConfig tempConfig = new VaultConfig()
            .address(System.getProperty("VAULT_ADDRESS"))
            .build();

        Vault tempVault = new Vault(tempConfig, 1);
        String token = tempVault.auth().loginByAppRole(
            "approle",
            System.getProperty("VAULT_ROLE_ID"),
            System.getProperty("VAULT_SECRET_ID")
        ).getAuthClientToken();

        VaultConfig vaultConfig = new VaultConfig()
            .address(System.getProperty("VAULT_ADDRESS"))
            .token(token)
            .build();
        vault = new Vault(vaultConfig, 1);
    }
}
