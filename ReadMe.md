# On The Map

This project is done for my Udacity iOS Nanodegree programm. 

An app with a map that shows information posted by other students. The map contains pins that show the location where other students have reported studying. By tapping on the pin users can see a URL for something the student finds interesting. The user is able to add their own data by posting a string that can be reverse geocoded to a location, and a URL.

![screenshots](https://github.com/OlehTitov/onTheMap/blob/master/onTheMapAppScreenshots.jpg?raw=true)

- the app informs the user if the login fails. It differentiates between a failure to connect, and incorrect credentials (i.e., wrong email or password).
- the app displays downloaded data in a tabbed view with two tabs: a map and a table.
- the foward geocoding accomplished using MKLocalSearch's startWithCompletionHandler().
- the networking code uses Swift's built-in URLSession library, not a third-party framework.
- the JSON parsing code uses Swift's built-in Codable, not a third-party framework.
- the networking and JSON parsing code is located in a dedicated API client class. The class uses closures for completion and error handling.

The goal of the project is to train skills in the areas as follows:
- usage of REST APIs
- networking calls (GET, POST, PUT)
- MapKit
