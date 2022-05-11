import 'dart:developer';
import 'dart:io';

class Library with searchList, mainprocess{
  var allBooks, lentBooks, bookList=[], userList=[];
  List genres=["Fiction", "Non-Fiction", "Drama", "Folktale", "Poetry"];

  //constructor that sets # of books to 0 and # of lent books to 0 for every instance of Library
  Library(){
    allBooks=0;
    lentBooks=0;
  }

  //return number of books in library's ownership including those lent out
  int numOfBooks(){
    return allBooks;
  }

  //return number of lent out books
  int numOfLent(){
    return lentBooks;
  }

  //add book to the collection
  //used this method than directly creating a new object of Books in main to ensure that a new Books object will be created only if there is a Library object
  void addBook(String title, String author, String genre, String ISBN){
    var book=new Books(title, author, genre, ISBN);
    bookList.add(book);
    allBooks++;
  }

  //lending a book to the user
  void lendBook(int userIndex){
    //loop does not end until user selects the finish adding option
    for(var doAddBook='1';doAddBook!='2';){

      //1 means add book, 2 means finish adding books
      stdout.write("\n(1)Add book ISBN\n(2)Finish adding\nType choice:");
      doAddBook=stdin.readLineSync()!;

      if(doAddBook=='1'){
        //loop does not end until user inputs correct ISBN
        for(int bookIndex=-1;bookIndex==-1;){
          stdout.write("\nEnter book ISBN: ");
          String ISBNbyUser=stdin.readLineSync()!;
          bookIndex=findBookIndex(bookList, ISBNbyUser);

          //function findBookIndex returns -1 if ISBN does not match any record in the library's books collection
          if(bookIndex==-1)
            print("Book not found. Please enter ISBN again.");
          else if(bookList[bookIndex].status==0)
            print("Book is currently borrowed by someone else.");
          else{
            //book is added to the user's borrowed books list
            //book's status in the library is changed to unavailable
            //library's count of lent books increments
            userList[userIndex].borrowedBooks.add(bookList[bookIndex]);
            bookList[bookIndex].status=0;
            lentBooks++;
          }
        }
      }
      else if(doAddBook=='2')
        print("\nBooks added to borrow list.\n");
      else
        print("Invalid choice. Please try again.");
    }
  }

  //library accepts returned books from user
  //all books in user's borrow list will be returned
  void acceptReturn(int userIndex){
    print("\nReturned books: ");
    if(userList[userIndex].borrowedBooks.length!=0){
      for(int i=0;i<userList[userIndex].borrowedBooks.length;){
        int bookIndex=findBookIndex(bookList, userList[userIndex].borrowedBooks[i].ISBN);
        userList[userIndex].borrowedBooks.removeAt(0);
        bookList[bookIndex].status=1;
        lentBooks--;
        print("\t${bookList[bookIndex].title} by ${bookList[bookIndex].author}");
      }
    }
    else
      print("\nNo borrowed books in your record.");
  }
  
  //adding new user
  //this method is used rather than creating an object in main method to ensure that a new User object will be created only if there is an existing Library object
  void newUser(String fullName, String address){
    var user=new User(fullName, address);
    userList.add(user);
  }
}
//main function starts here
void main(){
  var newLib=new Library();
  testAdd(newLib); //adding mock information of books and users to the library

  //loop does not end unless user inputs any keys other than 1, 2, 3, and 4
  for(bool exit=false;!exit;){
    print("Welcome to the Library!");
    stdout.write("(1)List of collection of books\n(2)Borrow book/s\n(3)Return book/s\n(4)View book/s in cart\nPress any other key to exit...\nType option: ");
    var mainOption=stdin.readLineSync();
    switch(mainOption){
      case '1':
        //browse books
        newLib.mainBrowseBooks(newLib);        
        break;
      case '2': 
        //borrow books
        newLib.mainBorrowBooks(newLib);
        break;
      case '3':
        //return borrowed books
        newLib.mainReturnBooks(newLib);
        break;
      case '4':
        //view books in cart (cart contains currently borrowed books)
        newLib.mainViewCart(newLib);
        break;
      default:
        exit=true;
        print("Exiting...");
        
        //next line can be commented out if you do not want to run the system testing for tracking of number of books
        systemTest(newLib);
    }
  }
}

//class for books containing necessary attributes
class Books{
  late String title;
  late String author;
  late String genre;
  late String ISBN;
  late int status; //0=borrowed, 1=available
  var booksBorrowed=[];

  //constructor to set values of attributes for every book instance
  Books(title, author, genre, ISBN){
    this.title=title;
    this.author=author;
    this.genre=genre;
    this.ISBN=ISBN;
    status=1; //status is immediately given value of 1 since it is available once added to collection
  }
}

//class for users containing necessary attributes
class User{
  late String fullName;
  late String address;
  var borrowedBooks=[];
  User(String fullName, String address){
    this.fullName=fullName;
    this.address=address;
  }
}

//mixin for index searching algorithms for books and users
mixin searchList{
  //method for finding certain book's index in library's users list
  //book is searched based on matching ISBN
  int findBookIndex(var listOfBooks, String ISBN){
    for(int i=0;i<listOfBooks.length;i++){
      if(listOfBooks[i].ISBN==ISBN)
        return i;
    }
    return -1;
  }

  //method for finding certain user's index in library's users list
  //user is searched based on matching full name and address
  int findUserIndex(var listOfUsers, String fullName, String address){
    for(int i=0;i<listOfUsers.length;i++){
      if(listOfUsers[i].fullName==fullName && listOfUsers[i].address==address)
        return i;
    }
    return -1;
  }
}

//mixin for processing of library's main menu
//chose to use mixin than defining these methods in the Library class for readability
mixin mainprocess{

  //method for browse books menu
  void mainBrowseBooks(var newLib){
    print("\n\n--BROWSE BOOKS--\n");
    //loop does not end until user inputs correct option
    for(;;){
      stdout.write("(1)View all\n(2)View by genre\nType option: ");
      var viewBooks=stdin.readLineSync();

      //view all books regardless of genre
      if(viewBooks=='1'){
        print("\nAll available books in the collection...\n");
        for(int i=0;i<newLib.bookList.length;i++){
          if(newLib.bookList[i].status==1){
            print("Title: ${newLib.bookList[i].title}");
            print("Author: ${newLib.bookList[i].author}");
            print("Genre: ${newLib.bookList[i].genre}");
            print("ISBN: ${newLib.bookList[i].ISBN}\n");
          }
        }
        break;
      }

      //view books based on a certain genre
      else if(viewBooks=='2'){
        stdout.write("\nGenres available...\n(1)Computer Science\n(2)Philosophy\n(3)Pure Science\n(4)Art and Recreation\n(5)History\nType option: ");
        int? viewGenres=int.tryParse(stdin.readLineSync()!);

        if(viewGenres!=null && ( viewGenres>0 || viewGenres<6)){
          print("\nAvailable books in ${newLib.genres[viewGenres-1]} genre...\n");
          int c=0;

          //finding and printing books under the genre selected by user
          for(int i=0;i<newLib.bookList.length;i++){
            if(newLib.genres[viewGenres-1]==newLib.bookList[i].genre && newLib.bookList[i].status==1){
              print("Title: ${newLib.bookList[i].title}");
              print("Author: ${newLib.bookList[i].author}");
              print("ISBN: ${newLib.bookList[i].ISBN}\n");
              c++; //counter to track number of books in a certain genre
            }
          }
          if(c==0)
            print("The library has no books in that genre.\n");
          break;
        }
        else
          print("Invalid choice. Please try again.\n");
      }
      else
        print("Invalid choice. Please try again.\n");
    }
     print("Redirecting to main menu....................................\n");
  }

  //method for borrow books menu
  void mainBorrowBooks(newLib){
    print("\n\n--BORROW BOOK/S--");
    //loop does not end until user inputs correct option
    for(;;){
      stdout.write("\n(1)New User\n(2)Old User\nType option: "); //1 for new user, 2 for old user
      var userStat=stdin.readLineSync();
      late int userIndex;

      if(userStat!='1' && userStat!='2')
        print("Invalid choice. Please try again.\n");
      else{
        //prompting user to input full name and address
        stdout.write("\nFull name: ");
        String fullName=stdin.readLineSync()!;
        stdout.write("Address: ");
        String address=stdin.readLineSync()!;

        //adding new user and taking index of last element in user list
        if(userStat=='1'){
          newLib.newUser(fullName, address);
          userIndex=newLib.userList.length-1;
          newLib.lendBook(userIndex);
          break;
        }
        //finding existing user and saving the index in userIndex
        else if(userStat=='2'){
          userIndex=newLib.findUserIndex(newLib.userList, fullName, address);
          if(userIndex==-1)
            print("Invalid selection. You are not an existing user. Select New User instead.");
          else{
            newLib.lendBook(userIndex);
            break;
          }
        }
      }
    }
     print("Redirecting to main menu....................................\n");
  }

  //method for returning of books menu
  void mainReturnBooks(var newLib){
    print("\n\n--RETURN BOOK/S--");

    //loop does not end until user inputs correct option
    for(;;){
      stdout.write("\n(1)New User\n(2)Old User\nType option: "); //1 for new user, 2 for old user
      var userStat=stdin.readLineSync();

      if(userStat!='1' && userStat!='2')
        print("Invalid choice. Please try again.");
      else{
        //prompting user to input full name and address
        stdout.write("\nFull name: ");
        String fullName=stdin.readLineSync()!;
        stdout.write("Address: ");
        String address=stdin.readLineSync()!;
        
        //adding new user to library's list of users
        if(userStat=='1'){
          newLib.newUser(fullName, address);
          print("\nNo books in your cart.\n");
          break;
        }
        //finding user in library's user list and storing the user's index in userIndex
        else if(userStat=='2'){
          int userIndex=newLib.findUserIndex(newLib.userList, fullName, address);

          //findUserIndex returns -1 if user is not found
          if(userIndex!=-1){
            newLib.acceptReturn(userIndex);
            break;
          }
          else
            print("We cannot find your name or address. Please enter those again.");
        }
      }
    }
     print("Redirecting to main menu....................................\n");
  }

  //method for view cart menu
  void mainViewCart(newLib){
    print("\n\n--VIEW BOOKS IN CART--");

    //loop does not end until user inputs the correct choice
    for(;;){
      stdout.write("\n(1)New User\n(2)Old User\nType option: "); //1 for new user, 2 for old user
      var userStat=stdin.readLineSync()!;

      if(userStat!='1' && userStat!='2')
        print("Invalid choice. Please try again.");
      else{
        //prompting user to input full name and address
        stdout.write("\nFull name: ");
        String fullName=stdin.readLineSync()!;
        stdout.write("Address: ");
        String address=stdin.readLineSync()!;

        //adding new user
        if(userStat=='1'){
          newLib.newUser(fullName, address);
          print("\nNo books in your cart.\n");
          break;
        }
        //finding existing user in the library's list of users
        else if(userStat=='2'){
          int userIndex=newLib.findUserIndex(newLib.userList, fullName, address);
          if(userIndex!=-1){
            print("\nBook/s in your cart: ");

            //printing all books in borrow list of user
            for(int i=0;i<newLib.userList[userIndex].borrowedBooks.length;i++){
              print("\t${newLib.userList[userIndex].borrowedBooks[i].title} by ${newLib.userList[userIndex].borrowedBooks[i].author}");
            }
            break;
          }
          else
            print("Are you sure you are an old user? We cannot find your name or address. Please enter those again.");
        }
      }
    }
    print("Redirecting to main menu....................................\n");
  }
}

//method to test if system keeps track of books count properly
//only call this when you need to test the system
void systemTest(var newLib){
  print("This is a test.");
  print("Number of lent books: ${newLib.numOfLent()}"); 
  print("Number of books in collection: ${newLib.numOfBooks()}");
 
}

//method to add mock information to the library
void testAdd(var newLib){
  newLib.addBook("Norse Mythology", "Matt Clayton", "Folktale", "979-3-41309-096-2"); 
  newLib.addBook("The Bell Jar", "Sylvia Plath", "Fiction", "978-1-12830-05-3");  
  newLib.addBook("Then She Was Gone: A Novel", "Lisa Jewell", "Drama", "978-1-60309-047-6");
  newLib.addBook("Atonement", "Ian McEwan", "Fiction", "978-1-891830-85-3");
  newLib.addBook("Before We Were Yours ", "Lisa Wingate", "Drama", "978-1-60309-016-2");
  newLib.addBook("The Art of Symmetry", "SQ Kim", "Nonfiction", "978-1-60309-265-4");
  newLib.addBook("Small Great Things: A Novel", "Jodi Picoult", "Drama", "978-1-543130-14-3");
  newLib.addBook("Alice's Adventures in Wonderland", "Lewis Carroll", "Fiction", "978-1-65309-067-1");
  newLib.addBook("The Language of Thorns", "Leigh Bardugo", "Folktale", "978-1-876830-35-3");
  newLib.addBook("Where the Crawdads Sing", "Delia Owens", "Drama", "978-1-51260309-316-2");
  newLib.addBook("Just Us", "Claudia Rankine", "Nonfiction", "978-1-40315-645-3");
  newLib.addBook("Hitler: Downfall", "Volker Ullrich", "Nonfiction", "978-1-51339-967-5");
  newLib.addBook("The Silent Wife", "Kerry Fisher", "Drama", "978-1-88809-203-4");
  newLib.addBook("The Book Thief", "Markus Zusak", "Fiction", "978-7-61209-817-6");
  
  
}
