USE prompttherapy;
insert into
    pts (name, hash, email, isAdmin, isVerified, createdAt, updatedAt)
values
    ('Prompt Admin', '$2a$08$2yDwkwaNfQIK3yD9Hyc72upxGR3eliOfC3OYvHsvtJoDUYOfRpWSe', 'joey@gmail.com', true, false, now(), now());
