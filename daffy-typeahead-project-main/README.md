# Jon's Daffy Typeahead Project

## General Overview:

To be totally honest, I found this take home interview to be a bit more challenging than I expected. Most of my Swift networking experience has been self taught so I spent more time than I'd like to admit getting the API and image loading working correctly. Despite the learning curve, I feel like I grew a ton from working on this and found it to be really fun. I focused more on getting the key components of the app working correctly instead of adding a bunch of additional features due to time constraints so it may seem a bit basic but (hopefully) everything works as expected.    

**What could be improved**

Asynchronous Image Loading:

I struggled deeply with asynchronously loading images in the MovieResultsViewControlller tableview. I kept running into an issue where an image would be set correctly and then another api call would finish and set an invalid image. I noticed that it seemed to be the case that popular movies would return their images quickly while less popular ones would take longer which makes sense given that users are more likely to query popular movies. 

- The biggest improvement I could make to this project is that after spending hours trying to fix the asynchronous image loading issue, I came up with 2 solutions that seemed to almost entirely solve the issue but I'm not sure if they're "correct". One of my solutions is good while the other I feel is hacky and likely not best practices. The first solution is that whenever a new query is entered in the search bar, it tells the viewModel to cancel all currently running image loading data tasks. I accomplished this by adding each image data task to a dictionary when it is created and having a cancelAll function that loops through the dictionary and cancels all existing tasks. This (ideally) prevents any irrelevant data tasks from completing. One problem with this solution was that if I typed quickly in the search bar, the app wasn't cancelling tasks fast enough to keep up and I would still end up with out of order image loading. My second solution was to create a timer to delay queries by 0.2 seconds so that the app had enough time to process cancelling all the old queries. The timer would reset whenever the searchBar changed and when it fired, it would tell the viewModel to query the api. The inclusion of the timer also means that if you add each character at a rate faster than 0.2 seconds per character, the app will only load the query when you stop. The timer made a huge difference in fixing the image loading problem as well as reducing the number of queries to the database while also avoiding a noticeable slowdown in the user experience. On the other hand, the timer feels hacky to me and could pose challenges down the line. 

Miscellaneous:

- As I said above, I don't have much experience with Swift networking. More generally, I'm not sure if I followed best practices or missed important steps. This is definitely something I'd like to learn more about in the future (whether or not you hire me, if you have recommendations please send them my way!)
-  I am not a UI designer. I assumed UI design was less important for a project like this since I wouldn't be designing on the job but the app is definitely very basic and could look a lot better. 
- I chose to use Storyboard because I find it fast and easy for solo projects. Ideally if this project were to scale, we would want all UI built programmatically. 

## Detailed Overview:

**Accessibility**:
- For the sake of time and effort, I did not test or verify that this app is accessible. If this were a real app, it would be worthwhile to test all of the UI to make sure Voiceover and other accessibility elements are working properly.

**Security/Reliability**: 
- Security: Since the user does not have the ability to make any post request, there is little security risk in this app. Since API calls are rate limited, there is the potential that a user could purposely make a large number of requests and make API calls impossible.

-  Reliability: Since we're relying on the TMDb API for pretty much everything, if it goes down, the app is obviously non-functional. There also could be issues with the account/API Key. I implemented a cache at one point but removed it after learning that URLSessionDataTask automatically caches requests. At the very least, if there are connectivity issues, the user should be able to see the default popular movies list assuming they've opened the app recently. We could also store the popular movies response every time it's queried so that assuming the user has used the app at least once, something should appear.  

**Scalability**: 
- The main scalability concern is the rate limiting of TMDb which would likely not be a problem if this were a real app as we would pay for the service. 

**Maintainability**:
- UI: The UI is very simple and uses all native UIKit elements. Currently, it is easy to add new features and make changes. 
- Networking: Adding a new api url and the functionality required to parse the response is easy. This would be necessary for almost any additional features. 

**Testing**: 
- I don't have much experience with testing (something else I'd really like to get better at) and I especially am unsure of how to test networking components. I included one simple test here but I couldn't test much else due to time constraints and the fact that almost every test I wanted to write would require networking. At the very least, I can say that I would've liked to test
    
    - ImageLoader: 
        - Valid posterPath response
        - Invalid posterPath URL
        - All errors
        - constructImageURL with unexpected characters 
    - MovieAPI:
        - Artifically generate nil URL
        - Test both path options and verify URL is expected
    - MovieDataProvider:  
        - loadPopularMovies:
            - All error paths
            - Mutliple queries quickly in a row
        - loadMovies: 
            - "" query
            - "Anything" query
            - "UnconventialCharacters!&^@#()!" query
            - All error paths
            - Mutliple queries quickly in a row
