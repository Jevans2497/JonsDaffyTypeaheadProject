# Jon's Daffy Typeahead Project

## General Thoughts:

I found this take home interview to be more challenging than expected! Most of my Swift networking experience has been self-taught, so it took me some extra time to get the API calls and image loading working correctly. I learned a ton from working on this and found it to be really fun. Due to time constraints, I focused mostly on getting the key components of the app working correctly, rather than adding additional features, so it's a bit basic, but hopefully everything works as expected.

**What Could Be Improved?**

Asynchronous Image Loading:

I struggled at first with asynchronously loading images in the MovieResultsViewControlller tableview. I worked through an issue where an image would be set correctly, but then another API call would finish and set an invalid image. I noticed that popular movies seemed to return their images more quickly than less popular ones, which makes sense given that users are more likely to query popular movies. 

The biggest improvement I could make to this project would be to clean up my approach to asynchronous image loading -- my approach works, but I'm not sure that it is techincally the "correct" approach. 

The solution I came up with consists of two main components:

- The first piece of my solution was that whenever a new query was entered in the search bar, it would tell the viewModel to cancel all currently-running image loading data tasks. I accomplished this by adding each image data task to a dictionary when it gets created, and having a cancelAll function that loops through the dictionary to cancel all existing tasks. This approach would ideally prevent any irrelevant data tasks from completing. One problem with this solution was that if I typed quickly in the search bar, the app wasn't cancelling tasks fast enough to keep up and I would still end up with out-of-order image loading. 

- The second piece of my solution was to delay queries by 0.2 seconds using a timer, so that the app would have enough time to process cancelling all the old queries. The timer would reset whenever the searchBar changed and when it fired, it would tell the viewModel to query the API. The inclusion of the timer also means that if a user adds each character at a rate faster than 0.2 seconds per character, the app will only load the query once they stop typing. The timer made a huge difference in fixing the image loading problem, as well as reducing the number of queries to the database. This approach did not cause any significant slowdown of the app. On the other hand, the timer feels hacky to me and could pose challenges down the line. 

Miscellaneous Other Improvements:

- As I have mentioned, I don't have much experience with Swift networking, so I'm not sure whether I followed best practices or missed important steps. This is definitely something I'd like to learn more about in the future (whether or not you hire me, if you have recommendations please send them my way!)
- I am not a UI designer, but the app is definitely very basic and could look a lot better. 
- I chose to use Storyboard because I find it fast and easy for solo projects. Ideally if this project were to scale, we would want all UI built programmatically. 

## Detailed Project Considerations:

Here I will outline various aspects that I considered while implementing this project, including accessibility, security, reliability, scalability, maintainability, and testing.

**Accessibility**:
- Due to time constraints, I was not able to verify that this app meets production-quality accessibility standards. Given more time, it would be worthwhile to test all of the UI to make sure Voiceover and other accessibility elements work properly.

**Security**: 
- Since the user does not have the ability to make any post requests, there is little security risk in this app. The main threat I forsee is that with API calls being rate limited, there is the potential that a user could purposely make a large number of requests and invalidate our key.

**Reliability**: 
- Since we're relying on the TMDb API for pretty much all of the app's content, if it were to go down, the app would be non-functional. There also could be issues with the account/API Key. I implemented a cache at one point but removed it after learning that URLSessionDataTask automatically caches requests. At the very least, even if there are connectivity issues, I think the user should be able to see the default popular movies list if they've opened the app recently. We could also store the popular movies response every time it's queried, so that it will always be populated as long as the user has used the app at least once.

**Scalability**: 
- The main scalability concern is the rate limiting of TMDb, which would likely not be a problem if this were a real app, since we would pay for the service. 

**Maintainability**:
- UI: The UI is very simple and uses all native UIKit elements. Currently, it is easy to add new features and make changes. 
- Networking: Adding a new API URL and the functionality required to parse the response is easy. This would be necessary for most additional features. 

**Testing**: 
- I don't have much experience with unit testing in Swift -- this is something else I'd really like to get better at. I am especially unsure of how to test networking components. I included one simple test here, but I couldn't test much else due to time constraints and the fact that almost every test I wanted to write would require networking. At the very least, I can say that I would've liked to test the following:
    
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
