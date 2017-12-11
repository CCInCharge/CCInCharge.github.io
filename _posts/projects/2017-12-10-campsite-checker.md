---
layout: post
title: "Campsite Checker"
status: "Deployed"
excerpt: "Web app for checking availability of campsite reservations within a certain location"
categories: projects
tags: [projects, web-development, python, react, javascript]
author: charles_chen
comments: true
share: true
modified: 2017-12-10 14:59:31 -0800
#image:
#  feature: 
#  credit: 
#  creditlink: 
---

[[Live App]](http://campsite-checker.com/) [[Source Code]](https://github.com/CCInCharge/campsite-checker)

Technologies: Python (backend), React (frontend)

[Campsite Checker](http://campsite-checker.com/) is a web app that allows you to search for campsite reservation availability. Enter in a location, a search radius around this location, and your check-in and check-out dates. The app will then give you a list of campsites within that search criteria that can be reserved. Here's how it looks:

![Screenshot of campsite-checker.com]({{ "/images/campsite_checker_screenshot.png" | absolute_url }})

Let's say we wanted to check out Yosemite. If you've ever tried to get a campsite at Yosemite before, especially a campsite in Yosemite Valley, you can relate to how it's as simple as logging on to the reservation website and being disappointed. It is much easier in the winter though, so let's try that:

![Screenshot of search term on campsite-checker.com]({{ "/images/campsite_checker_search.png" | absolute_url }})

And, some time later, voila! We have found quite a few campsites within our desired dates. If we click through on the date links, we can make a reservation and go camping.

![Screenshot of search results on campsite-checker.com]({{ "/images/campsite_checker_results.png" | absolute_url }})

#### Inspiration:
So, it's probably not too difficult to guess how I came up with the idea. I really enjoy doing things in the outdoors - I find that hiking and camping always destresses me, and no other hobby out there has quite the same effect for me. I feel that some of the best memories are made when out day-hiking a trail, backpacking to a gorgeous remote forest, or simply enjoying a campfire, a beer, and good food with good people. It can be really challenging to get a campsite at times though - it can be very time consuming to find what campsites are nearby. Even once you've done that, it can be sheer luck to find which (if any) campsites are available for the weekend for which you'd like to go camping.

This is complicated by the fact that, often times, the website you need to go through to make campsite reservations doesn't provide the best user experience. You are allowed to search a specific campground for availability. Once your search goes through, you're not really even provided a list of campsites that are available - you're just given a list of campsites in that campground as well as a two-week window, and you have to go through and manually look through the results to see if there's something that meets your needs.

As an example, say you wanted to get a campsite at Yosemite. Yosemite has 7 campgrounds that are on the reservation system. Ideally, you would just like to search Yosemite for availability for your desired weekend in all 7 campgrounds, and get back a list of all campgrounds that meet that criteria. This is what my app does. In order to do this using the official website, you need to check to open up 7 tabs (one for each campground), do a search for your date range, and then manually check all the campsites in each of the 7 campgrounds to see if there's any avaiability. Not the most user-friendly experience, and this turns planning a simple weekend trip into a pretty time-consuming affair.

I felt I could do better - I also wanted to learn a little bit about React, and hence, Campsite Checker was born.

#### How it works:
There's an [RIDB API](http://usda.github.io/RIDB/) available for some information regarding the National Parks Service, the US Forest Service, and related organizations. One really useful feature is the ability to search for nearby recreational facilities, given a latitude and longitude and radius. This is exactly a feature we want to have in our app, although searching by latitude and longitude isn't very user friendly. However, there is a [Google Maps Geocoding API](https://developers.google.com/maps/documentation/geocoding/start) that takes a search term and geocodes it (converts into a latitude and longitude). We combine these two functionalities on the backend (Python) as the first step for when a user submits a search on our website.
{% highlight python %}
try:
    lat,lon = geocode_location(args['location'])
except CantAccessAPI as e:
    print(e)
    # Redirect to previous page with error
    return
except CantFindLocation as e:
    print(e)
    # Redirect to previous page with error
    return
campgrounds = get_campgrounds_from_API(lat, lon, args['radius'])
{% endhighlight %}

The geocode_location function calls the Google Maps API to get latitude and longitude, and the get_campgrounds_from_API function calls the RIDB API to get nearby campgrounds.

The next part is to get actual campsite availability, given the names of the campgrounds. The RIDB API sadly does not actually return campsite availability - the only way to do this is to access the actual recreation.gov website. However, information in the RIDB API response can be used to construct an URL for the recreation.gov's landing page for each individual campground. Given this information, we then need to find a way to actually obtain availability.

Here is an example of what the website looks like when we follow one of the URLs constructed, as discussed previously:

![Screenshot of Upper Pines Landing Page]({{ "/images/Upper_Pines_landing.png" | absolute_url }})

If we were to use this website as intended (i.e., manually), we'd click on the "Date Range Availability" link and start tediously looking through the campsites for availability.

![Screenshot of Upper Pines Availability]({{ "/images/Upper_Pines_availability.png" | absolute_url }})

The squares marked with "A" denote a campsite that is available for that specific date. We could then do it for all 237 campsites in Upper Pines.

If we want to do this programatically, the way that Campsite Checker does, we need to make use of the MechanicalSoup library to emulate a web browser session, and the BeautifulSoup library to screen scrape the response as we "browse" through the pages. We then use MechanicalSoup to go through each campsite, for all dates within our desired avaiability range, and make note of the campsites that are available.

{% highlight python %}
campsite = row.find("div", class_="siteListLabel").get_text()
days = row.find_all("td", class_="status")
for idx, day in enumerate(days):
    date = first_date + timedelta(days=idx)
    if date > last_date or date >= end_date:
        return
    elif "a" in day.attrs["class"]:
        reservationUrl = "https://www.recreation.gov" + day.find("a").attrs["href"] + "&lengthOfStay=1"
        campground.add_date(campsite, date, reservationUrl)
{% endhighlight %}

In the code snippet above, a row represents a campsite, and we're looking for dates that have the "a" attribute, which denotes that the campsite is available for that day. We do this for all campsites and all dates, and store the information in our campground object. We then do this for all of the other campgrounds that are within our search radius.

We end up with a list of Campground objects. Each Campground has a name of the campground, a list of the available campsites, and the dates for which they are available. Then, all we must do is return this as a JSON response to the front-end. The Flask framework is a great way to get a quick REST API like this set up.

{% highlight python %}
def get_all_campsite_availability(campgrounds, start_date, end_date):
    for campground in campgrounds:
        get_availability(campground, campground.url, start_date, end_date)
    return campgrounds.serialize()
{% endhighlight %}

And, there you have it! Now that we have this JSON response on the frontend, we can parse it out into a table to have our list of campsite availability, resulting in a much easier-to-use interface than the official website.