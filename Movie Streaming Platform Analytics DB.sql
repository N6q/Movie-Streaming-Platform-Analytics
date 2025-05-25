-- Create Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    JoinDate DATE,
    SubscriptionType VARCHAR(20)  -- Free, Basic, Premium
);

-- Create Movies table
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(100),
    Genre VARCHAR(50),
    ReleaseYear INT,
    DurationMinutes INT
);

-- Create WatchHistory table
CREATE TABLE WatchHistory (
    WatchID INT PRIMARY KEY,
    UserID INT,
    MovieID INT,
    WatchDate DATE,
    WatchDuration INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

-- Insert sample data into Users
INSERT INTO Users (UserID, FullName, Email, JoinDate, SubscriptionType) VALUES
(1, 'Ali Al Hinai', 'ali@example.com', '2024-01-01', 'Premium'),
(2, 'Noor Al Busaidi', 'noor@example.com', '2024-02-15', 'Basic'),
(3, 'Hassan Al Rawahi', 'hassan@example.com', '2024-03-10', 'Free'),
(4, 'Muna Al Lawati', 'muna@example.com', '2024-04-05', 'Premium'),
(5, 'Salim Al Zadjali', 'salim@example.com', '2024-05-01', 'Basic');

-- Insert sample data into Movies
INSERT INTO Movies (MovieID, Title, Genre, ReleaseYear, DurationMinutes) VALUES
(1, 'The Silent Ocean', 'Sci-Fi', 2023, 120),
(2, 'Omani Roots', 'Documentary', 2022, 90),
(3, 'Fast Track', 'Action', 2024, 130),
(4, 'Code & Coffee', 'Drama', 2023, 110),
(5, 'The Last Byte', 'Thriller', 2023, 105);

-- Insert sample data into WatchHistory
INSERT INTO WatchHistory (WatchID, UserID, MovieID, WatchDate, WatchDuration) VALUES
(1, 1, 1, '2025-05-10', 120),
(2, 2, 2, '2025-05-11', 80),
(3, 3, 3, '2025-05-12', 60),
(4, 4, 1, '2025-05-12', 90),
(5, 5, 5, '2025-05-13', 105);

--------------------------------------------------------------------------------
-- Beginner Level Queries
--------------------------------------------------------------------------------

-- 1. Total Number of Users
SELECT COUNT(*) AS TotalUsers FROM Users;

-- 2. Average Duration of All Movies
SELECT AVG(DurationMinutes) AS AvgMovieDuration FROM Movies;

-- 3. Total Watch Time (All users, all movies)
SELECT SUM(WatchDuration) AS TotalWatchTime FROM WatchHistory;

-- 4. Number of Movies per Genre
SELECT Genre, COUNT(*) AS MovieCount
FROM Movies
GROUP BY Genre;

-- 5. Earliest User Join Date
SELECT MIN(JoinDate) AS EarliestJoinDate FROM Users;

-- 6. Latest Movie Release Year
SELECT MAX(ReleaseYear) AS LatestReleaseYear FROM Movies;

--------------------------------------------------------------------------------
-- Intermediate Level Queries
--------------------------------------------------------------------------------

-- 4. Number of Users Per Subscription Type
SELECT SubscriptionType, COUNT(*) AS UserCount
FROM Users
GROUP BY SubscriptionType;

-- 5. Total Watch Time per User
SELECT u.UserID, u.FullName, COALESCE(SUM(w.WatchDuration), 0) AS TotalWatchTime
FROM Users u
LEFT JOIN WatchHistory w ON u.UserID = w.UserID
GROUP BY u.UserID, u.FullName;

-- 6. Average Watch Duration per Movie
SELECT m.MovieID, m.Title, COALESCE(AVG(w.WatchDuration), 0) AS AvgWatchDuration
FROM Movies m
LEFT JOIN WatchHistory w ON m.MovieID = w.MovieID
GROUP BY m.MovieID, m.Title;

-- 7. Average Watch Time per Subscription Type
SELECT u.SubscriptionType, AVG(COALESCE(w.WatchDuration, 0)) AS AvgWatchTime
FROM Users u
LEFT JOIN WatchHistory w ON u.UserID = w.UserID
GROUP BY u.SubscriptionType;

-- 8. Number of Views per Movie (Including Zero)
SELECT m.MovieID, m.Title, COUNT(w.WatchID) AS ViewsCount
FROM Movies m
LEFT JOIN WatchHistory w ON m.MovieID = w.MovieID
GROUP BY m.MovieID, m.Title;

-- 9. Average Movie Duration per Release Year
SELECT ReleaseYear, AVG(DurationMinutes) AS AvgMovieDuration
FROM Movies
GROUP BY ReleaseYear;

--------------------------------------------------------------------------------
-- Advanced Level Queries
--------------------------------------------------------------------------------

-- 7. Most Watched Movie (By Total Watch Duration)
SELECT TOP 1 m.MovieID, m.Title, SUM(w.WatchDuration) AS TotalWatchTime
FROM Movies m
JOIN WatchHistory w ON m.MovieID = w.MovieID
GROUP BY m.MovieID, m.Title
ORDER BY TotalWatchTime DESC;


-- 8. Users Who Watched More Than 100 Minutes Total
SELECT u.UserID, u.FullName, SUM(w.WatchDuration) AS TotalWatchTime
FROM Users u
JOIN WatchHistory w ON u.UserID = w.UserID
GROUP BY u.UserID, u.FullName
HAVING SUM(w.WatchDuration) > 100;

-- 9. Total Watch Time per Genre
SELECT m.Genre, SUM(w.WatchDuration) AS TotalWatchTime
FROM Movies m
JOIN WatchHistory w ON m.MovieID = w.MovieID
GROUP BY m.Genre;

-- 10. Identify Binge Watchers (Users Who Watched 2 or More Movies in One Day)
SELECT UserID, WatchDate, COUNT(DISTINCT MovieID) AS MoviesWatched
FROM WatchHistory
GROUP BY UserID, WatchDate
HAVING COUNT(DISTINCT MovieID) >= 2;

-- 11. Genre Popularity (Total Watch Duration by Genre)
SELECT m.Genre, SUM(w.WatchDuration) AS TotalWatchDuration
FROM Movies m
JOIN WatchHistory w ON m.MovieID = w.MovieID
GROUP BY m.Genre
ORDER BY TotalWatchDuration DESC;

-- 12. User Retention Insight: Number of Users Joined Each Month
-- (For MySQL: DATE_FORMAT, for others adapt accordingly)
SELECT FORMAT(JoinDate, 'yyyy-MM') AS JoinMonth, COUNT(*) AS UsersJoined
FROM Users
GROUP BY FORMAT(JoinDate, 'yyyy-MM')
ORDER BY JoinMonth;



