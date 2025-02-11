/*
======================================
    CreateUser - Registers a New User
    - This procedure is only called **once** when a user is first created.
    - Inserts a new user into the `Users` table.
======================================
*/
CREATE PROCEDURE CreateUser
    @userID UNIQUEIDENTIFIER,
    @joinDate DATETIME DEFAULT GETDATE()
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Users (userID, joinDate) 
    VALUES (@userID, @joinDate);
END;

/*
======================================
    CreatePost - User Creates a Post
    - Generates a new GUID for the post.
    - Inserts the post into the `Posts` table.
    - Supports optional image URLs.
======================================
*/
CREATE PROCEDURE CreatePost
    @postID UNIQUEIDENTIFIER OUTPUT,
    @userID UNIQUEIDENTIFIER,
    @postContent VARCHAR(200),
    @pictureUrl VARCHAR(50) NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @postID = NEWID();  
    INSERT INTO Posts (postID, userID, postContent, dateAdded, pictureUrl)
    VALUES (@postID, @userID, @postContent, GETDATE(), @pictureUrl);
END;

/*
======================================
    GetPosts - Fetch All Posts
    - Retrieves all posts along with user join date.
    - Ordered by newest first.
======================================
*/
CREATE PROCEDURE GetPosts
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        p.postID, p.userID, u.joinDate, 
        p.postContent, p.pictureUrl, p.dateAdded
    FROM Posts p
    JOIN Users u ON p.userID = u.userID
    ORDER BY p.dateAdded DESC;
END;

/*
======================================
    GetPostsByUser - Fetch Posts by a Specific User
    - Retrieves posts made by a given user.
======================================
*/
CREATE PROCEDURE GetPostsByUser
    @userID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT postID, postContent, pictureUrl, dateAdded
    FROM Posts
    WHERE userID = @userID
    ORDER BY dateAdded DESC;
END;

/*
======================================
    AddComment - User Adds a Comment
    - Generates a new GUID for the comment.
    - Inserts the comment into the `Comments` table.
======================================
*/
CREATE PROCEDURE AddComment
    @commentID UNIQUEIDENTIFIER OUTPUT,
    @userID UNIQUEIDENTIFIER,
    @postID UNIQUEIDENTIFIER,
    @commentContent VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    SET @commentID = NEWID();
    INSERT INTO Comments (commentID, userID, postID, commentContent, dateAdded)
    VALUES (@commentID, @userID, @postID, @commentContent, GETDATE());
END;

/*
======================================
    GetCommentsByPost - Fetch Comments for a Post
    - Retrieves all comments related to a given post.
    - Ordered from oldest to newest.
======================================
*/
CREATE PROCEDURE GetCommentsByPost
    @postID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.commentID, c.userID, c.commentContent, c.dateAdded
    FROM Comments c
    WHERE c.postID = @postID
    ORDER BY c.dateAdded ASC;
END;

/*
======================================
    DeletePost - Remove a Post and Its Comments
    - Deletes the post from `Posts`.
    - Since we have `ON DELETE CASCADE`, comments are automatically deleted.
======================================
*/
CREATE PROCEDURE DeletePost
    @postID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Posts WHERE postID = @postID;
END;

/*
======================================
    DeleteComment - Remove a Specific Comment
    - Deletes a comment by its ID.
======================================
*/
CREATE PROCEDURE DeleteComment
    @commentID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Comments WHERE commentID = @commentID;
END;


