// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChainShelf {
    // 📖 Struct to store book info
    struct Book {
        string title;
        bool isBorrowed;
        address borrowedBy;
    }

    // 🧾 A mapping from book ID to Book
    mapping(uint => Book) public books;

    // 📚 Counter for total books added
    uint public totalBooks;

    // 🧍‍♂️ The library owner
    address public owner;

    // 🔔 Events (for transparency)
    event BookAdded(uint bookId, string title);
    event BookBorrowed(uint bookId, address borrower);
    event BookReturned(uint bookId, address borrower);

    // ⚙️ Constructor: runs once when deployed
    constructor() {
        owner = msg.sender;
    }

    // 🧩 Modifier: restricts functions to only owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // 🪶 Add a new book (only owner)
    function addBook(string memory _title) public onlyOwner {
        totalBooks++;
        books[totalBooks] = Book(_title, false, address(0));
        emit BookAdded(totalBooks, _title);
    }

    // 📘 Borrow a book
    function borrowBook(uint _bookId) public {
        Book storage book = books[_bookId];
        require(_bookId > 0 && _bookId <= totalBooks, "Invalid book ID");
        require(!book.isBorrowed, "Book is already borrowed");

        book.isBorrowed = true;
        book.borrowedBy = msg.sender;

        emit BookBorrowed(_bookId, msg.sender);
    }

    // 📗 Return a book
    function returnBook(uint _bookId) public {
        Book storage book = books[_bookId];
        require(book.isBorrowed, "Book is not borrowed");
        require(book.borrowedBy == msg.sender, "You didn't borrow this book");

        book.isBorrowed = false;
        book.borrowedBy = address(0);

        emit BookReturned(_bookId, msg.sender);
    }

    // 🔍 View book details
    function getBook(uint _bookId) public view returns (string memory title, bool isBorrowed, address borrowedBy) {
        Book memory book = books[_bookId];
        return (book.title, book.isBorrowed, book.borrowedBy);
    }
}
