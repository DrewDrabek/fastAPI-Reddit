-- Enable the uuid-ossp extension if not already enabled -  this is needed in postgres for the uuid 
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- This si the format for the create table 

-- this table is going to be used with users in the future we will lab with an IDP and will create a local que with rabit mq or something to create new users 


CREATE TABLE Users (
    userID UUID PRIMARY KEY DEFAULT uuid_generate_v4(), -- the default here is if it is not provided it will make one
    joinDate TIMESTAMP NOT NULL DEFAULT NOW() -- the timestamp default is the creation time
);

-- This is the posts table

CREATE TABLE Posts (
    postID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    userID UUID NOT NULL,
    postContent VARCHAR(200) NOT NULL,
    dateAdded TIMESTAMP NOT NULL DEFAULT NOW(),
    pictureUrl VARCHAR(50) NULL,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE
);

-- this is the comments table

CREATE TABLE Comments (
    commentID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    userID UUID NOT NULL,
    postID UUID NOT NULL,
    commentContent VARCHAR(500) NOT NULL,
    dateAdded TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE,
    FOREIGN KEY (postID) REFERENCES Posts(postID) ON DELETE CASCADE
);
