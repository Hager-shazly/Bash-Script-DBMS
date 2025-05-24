# Bash Script DBMS 

A lightweight, self-contained Database Management System implemented purely in Bash scripting.
This project provides core database functionality through an intuitive command-line interface without requiring external database engines.

##  Key Features

### Database Management
-  Create new databases
-  List all available databases
-  Connect to existing databases
-  Drop (delete) databases

### Table Operations
-  Create tables with custom columns
-  List all tables in current database
-  Delete tables

### Data Manipulation
-  Insert records into tables
-  Select/filter records (with basic querying)
-  Update existing records
-  Delete records

### User Experience
-  Interactive menu-driven interface
-  Helper functions for common operations
-  Basic error handling and validation

##  Project Structure
Bash-Script-DBMS/
├── main.sh # Main entry point
├── helpers.sh # Shared utility functions
│
├── database_operations/
├── createdb.sh # Create new database
├── listdbs.sh # List all databases
├── connect.sh # Connect to database
└── dropdb.sh # Delete database
│
├── table_operations/
├── createTable.sh # Create new table
├── listTables.sh # List all tables
└── dropTable.sh # Delete table
│
└── data_operations/
├── insertTable.sh # Insert records
├── selectFrom.sh # Query records
├── updateTable.sh # Update records
└── deleteFrom.sh # Delete records

## Usage Example

#$ ./main.sh
Welcome to Bash DBMS!

1. Create Database
2. List Databases
3. Connect to Database
4. Drop Database
5. Exit

Enter your choice: 1
Enter database name: mydb
Database 'mydb' created successfully!

