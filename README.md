# Library
A project to create a library with books in it!

Books can be added, checked out, and deleted by the user. 

# Approach
Below are the implementation details of the project. 

## Model 

#### Book
I created a class called `Book`, which would be the object the UI relies on for populating its views.

`Book` contains the following details:

- Title

- Author

- Publisher

- Categories

- Last Checked Out By

- Last Checked Out At


#### LibraryManager

I created a static instance of a class called `LibraryManager`, which I used for managing the data. 
It manages every call to the server, and subsequently sends notifications to the `NotificationCenter` or triggers an alert.


It uses `URLSession` calls to retreive all books in the library, check out a specific book, delete a specific book, 
or delete all books in the library.

It also converts the `Book` objects to `NSDictionary` objects prior to adding them as params to server calls. Upon retreiving
data from the server, the `LibraryManager` converts the objects into `Book`s.

## User Interface

#### Navigation Controller

The app relies on a `UINavigationController` as the root controller. 

#### Library View

The first view shown is a `UITableViewController` to display all available books in the library. 

A user can:
- Select a table cell to view more details about a book
- Tap on the Add button on the left side of the navigation bar to add a new book to the library
- Tap on the More button on the right side of the navigation bar to delete all books in the library

#### Book Checkout View

This view shows all details of the selected book. A user can checkout this book, or delete it (or edit it – more details about this
hidden option below)

#### Add Book View

A user can use this view to add a new book to the library. Title and Author are required, while the rest of the fields are not.


## Considerations

1. I used a light yellow color scheme because it seemed more natural when thinking about reading/writing. Perhaps this is 
an influence of Apple's Notes app.
2. The app icon is created from [this icon](https://www.flaticon.com/free-icon/open-magazine_88179#term=book&page=1&position=26).
3. The requirement stating "The app should allow users to update a book information" was a bit unclear to me. I understood it as
though any attribute of a book could be changed. Upon attempts to `PUT` book information back to the server, I noticed that it
was being checked out instead of updating (the `lastCheckedOut` parameter was the only one changing). So I hid the edit button,
kept the code I had written, and left a static variable called `showEditOptions` in the `AppDelegate` that allows you to 
test this yourself.
