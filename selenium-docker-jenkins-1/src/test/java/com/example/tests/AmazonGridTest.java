package com.example.tests;

import org.openqa.selenium.MutableCapabilities;
import org.openqa.selenium.Platform;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.edge.EdgeOptions;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.testng.annotations.*;

import java.net.MalformedURLException;
import java.net.URL;
import java.time.Duration;

public class AmazonGridTest {

    // Use env var GRID_URL or default to http://selenium-hub:4444
    private String gridUrl = System.getenv().getOrDefault("GRID_URL", "http://selenium-hub:4444");

    @DataProvider(name = "browsers", parallel = false)
    public Object[][] browsers() {
        return new Object[][]{
                {"chrome"},
                {"firefox"},
                {"edge"}
        };
    }

    @Test(dataProvider = "browsers")
    public void openAmazonAndPrintTitle(String browser) throws MalformedURLException {
        MutableCapabilities options;

        switch (browser.toLowerCase()) {
            case "chrome":
                ChromeOptions chromeOptions = new ChromeOptions();
                chromeOptions.setCapability("platformName", "ANY");
                options = chromeOptions;
                break;
            case "firefox":
                FirefoxOptions firefoxOptions = new FirefoxOptions();
                firefoxOptions.setCapability("platformName", "ANY");
                options = firefoxOptions;
                break;
            case "edge":
                EdgeOptions edgeOptions = new EdgeOptions();
                edgeOptions.setCapability("platformName", "ANY");
                options = edgeOptions;
                break;
            default:
                throw new IllegalArgumentException("Unsupported browser: " + browser);
        }

        // Set test name in capability (optional)
        options.setCapability("se:recordName", "AmazonTest-" + browser);

        URL remoteUrl = new URL(gridUrl + "/wd/hub");
        RemoteWebDriver driver = new RemoteWebDriver(remoteUrl, options);

        try {
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
            driver.get("https://www.amazon.in");    // or amazon.com
            System.out.println("Browser: " + browser + " --> Title: " + driver.getTitle());
        } finally {
            driver.quit();
        }
    }
}
