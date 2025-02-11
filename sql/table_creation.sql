-- Enable the uuid-ossp extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE Users (
    userID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    joinDate TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE Posts (
    postID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    userID UUID NOT NULL,
    postContent VARCHAR(200) NOT NULL,
    dateAdded TIMESTAMP NOT NULL DEFAULT NOW(),
    pictureUrl VARCHAR(50) NULL,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE
);

CREATE TABLE Comments (
    commentID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    userID UUID NOT NULL,
    postID UUID NOT NULL,
    commentContent VARCHAR(500) NOT NULL,
    dateAdded TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE,
    FOREIGN KEY (postID) REFERENCES Posts(postID) ON DELETE CASCADE
);
