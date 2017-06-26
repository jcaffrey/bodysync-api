-- dummy data
-- created 2/22/17, does not yet include records for exerciseSets, exercises, etc.
-- N.B.: this is not the best way to do this

-- pts

/* notes on passwords and hashed passwords:
 * when testing the api (in postman or with curl at the command line), you should sign in
 * to get a token (which you should store as 'x-access-token':token in the header to simulate
 * the browser's storage) for subsequent resource requests, and you should sign in using a
 * plaintext password. We have inserted hashes into the db because these are not
 * created using the controller of course (see the schema for bcrypt functionality).
 *
 * https://bcrypt-generator.com
 * $2a$08$dtV592jmtL7UM1O0sacUGe57ndCFlAeXUH/wXaP0FE1DmJ62EWPti is bcrypted jeremypw
 * $2a$08$2yDwkwaNfQIK3yD9Hyc72upxGR3eliOfC3OYvHsvtJoDUYOfRpWSe is bcrypted joeypw
 * $2a$08$KyePVbpTFRdPaDcc1xAtOOCacEh6X.e.6Ud0Z/AKLJHsMHNYkqKku is bcrypted davidpw
 * $2a$08$tfLDCj0ypAzW20TxF4B7N.hqUhzmdYBUk5.RsE3QRbiAZVvh51Pa. is bcrypted joshpw
 */
insert into
    pts (name, hash, phoneNumber, phoneProvider, email, isAdmin, createdAt, updatedAt)
values
    ('Jeremy Welborn', '$2a$08$dtV592jmtL7UM1O0sacUGe57ndCFlAeXUH/wXaP0FE1DmJ62EWPti', '16174627953', 'att', 'jeremy@gmail.com', false, now(), now()),
    ('Joey Caffrey', '$2a$08$2yDwkwaNfQIK3yD9Hyc72upxGR3eliOfC3OYvHsvtJoDUYOfRpWSe', '12017254565', 'att', 'joey@gmail.com', false, now(), now()),
    -- temp admin, change if schema changes
    ('David Malan', '$2a$08$KyePVbpTFRdPaDcc1xAtOOCacEh6X.e.6Ud0Z/AKLJHsMHNYkqKku', '1234567890', 'att', 'david@gmail.com', true, now(), now()),
    ('Josh Seides', '$2a$08$tfLDCj0ypAzW20TxF4B7N.hqUhzmdYBUk5.RsE3QRbiAZVvh51Pa.', '1234567892', 'att', 'josh6810@gmail.com', true, now(), now());

-- patients

insert into patients
    (name, hash, phoneNumber, phoneProvider, email, isRestrictedFromRom, surgeryType, surgeonName, age, ptId, createdAt, updatedAt, ptNotes, proPicUrl)
values
    ('Josh Smith', '$2a$08$tfLDCj0ypAzW20TxF4B7N.hqUhzmdYBUk5.RsE3QRbiAZVvh51Pa.', '16788233590', 'att', 'josh1@gmail.com', true, 'BeingABaby', 'Bob Smith', 12, (select id from pts where name = 'Jeremy Welborn'), now(), now(), 'What a beast.', 'https://s3.amazonaws.com/bodysync-photo-upload/Josh+Seides.jpg'),
    ('Josh Seides', '$2a$08$tfLDCj0ypAzW20TxF4B7N.hqUhzmdYBUk5.RsE3QRbiAZVvh51Pa.', '16788233590', 'att', 'josh@gmail.com', true, 'BeingABaby', 'Jim Green', 19, (select id from pts where name = 'Joey Caffrey'), now(), now(), 'This dude is amazing!', 'https://s3.amazonaws.com/bodysync-photo-upload/Josh+Seides.jpg'),
    ('David Malan', '$2a$08$tfLDCj0ypAzW20TxF4B7N.hqUhzmdYBUk5.RsE3QRbiAZVvh51Pa.', '16788233590', 'att', 'dave@gmail.com', false, 'BeingABaby', 'Lane Rogers', 12, (select id from pts where name = 'Joey Caffrey'), now(), now(), 'Great work so far.', 'https://s3.amazonaws.com/bodysync-photo-upload/David+Malan.jpg'),
    ('Zamyla Chan', '$2a$08$tfLDCj0ypAzW20TxF4B7N.hqUhzmdYBUk5.RsE3QRbiAZVvh51Pa.', '16788233590', 'att', 'zamyla@gmail.com', false, 'Walkthroughs', 'Mats Zuccarello', 12, (select id from pts where name = 'Joey Caffrey'), now(), now(), null, 'https://s3.amazonaws.com/bodysync-photo-upload/Zamyla+Chan.jpg'),
    ('Sam Pelletier', '$2a$08$tfLDCj0ypAzW20TxF4B7N.hqUhzmdYBUk5.RsE3QRbiAZVvh51Pa.', '16788233590', 'att', 'sam@gmail.com', false, 'Rude', 'Henrik Lundqvist', 12, (select id from pts where name = 'Joey Caffrey'), now(), now(), 'Needs some help.', 'https://s3.amazonaws.com/bodysync-photo-upload/Sam+Pelletier.jpg');

-- injuries
insert into injuries
    (name, patientId, createdAt, updatedAt)
values
    ('shoulder injury', (select id from patients where name = 'Josh Seides'), now(), now()),
    ('broken arm', (select id from patients where name = 'Josh Seides'), now(), now()),
    ('stubbed toe', (select id from patients where name = 'David Malan'), now(), now()),
    ('sprained ankle', (select id from patients where name = 'Zamyla Chan'), now(), now()),
    ('broken thumb', (select id from patients where name = 'Sam Pelletier'), now(), now()),
    ('sore back', (select id from patients where name = 'Sam Pelletier'), now(), now()),
    ('sketchy face', (select id from patients where name = 'Sam Pelletier'), now(), now());


-- romMetrics
insert into romMetrics
    (name, startRange, endRangeGoal, createdAt, updatedAt, injuryId)
values
    ('External Shoulder Rotation', '30', '90', now(), now(), 1),
    ('Arm Rotation', '30', '90', now(), now(), 2),
    ('Toe Rotation', '5', '10', now(), now(), 3),
    ('Ankle Flexion', '70', '90', now(), now(), 4),
    ('Thumb Rotation', '0', '90', now(), now(), 5),
    ('Back Angle', '80', '90', now(), now(), 6),
    ('Face Coolness', '0', '1000', now(), now(), 7);

-- romMetricMeasures
insert into romMetricMeasures
    (name, degreeValue, nextGoal, dayOfNextGoal, dayMeasured, createdAt, updatedAt, romMetricId, endRangeGoal)
values
    ('firstMeasure', 32, 35, DATE_ADD(NOW(), INTERVAL 7 DAY), now(), now(), now(), 1, 90),
    ('secondMeasure', 35, 43, DATE_ADD(NOW(), INTERVAL 14 DAY), DATE_ADD(NOW(), INTERVAL 7 DAY), now(), now(), 1, 90),
    ('thirdMeasure', 40, 50, DATE_ADD(NOW(), INTERVAL 21 DAY), DATE_ADD(NOW(), INTERVAL 14 DAY), now(), now(), 1, 90),
    ('fourthMeasure', 45, 58, DATE_ADD(NOW(), INTERVAL 28 DAY), DATE_ADD(NOW(), INTERVAL 21 DAY), now(), now(), 1, 90),
    ('fifthMeasure', 53, 70, DATE_ADD(NOW(), INTERVAL 35 DAY), DATE_ADD(NOW(), INTERVAL 28 DAY), now(), now(), 1, 90),
    ('sixthMeasure', 65, 81, DATE_ADD(NOW(), INTERVAL 42 DAY), DATE_ADD(NOW(), INTERVAL 35 DAY), now(), now(), 1, 90),
    ('seventhMeasure', 77, 90, DATE_ADD(NOW(), INTERVAL 49 DAY), DATE_ADD(NOW(), INTERVAL 42 DAY), now(), now(), 1, 90),
    ('firstMeasure', 17, 25, DATE_ADD(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL -21 DAY), now(), now(), 2, 90),
    ('secondMeasure', 77, 100, DATE_ADD(NOW(), INTERVAL 14 DAY), DATE_ADD(NOW(), INTERVAL -14 DAY), now(), now(), 2, 90),
    ('firstMeasure', 4, 35, DATE_ADD(NOW(), INTERVAL 7 DAY), now(), now(), now(), 3, 10),
    ('firstMeasure', 18, 35, DATE_ADD(NOW(), INTERVAL 7 DAY), now(), now(), now(), 4, 90),
    ('firstMeasure', 67, 90, DATE_ADD(NOW(), INTERVAL 7 DAY), now(), now(), now(), 5, 90),
    ('firstMeasure', 88, 90, DATE_ADD(NOW(), INTERVAL 7 DAY), now(), now(), now(), 6, 90),
    ('firstMeasure', 56, 580, DATE_ADD(NOW(), INTERVAL 7 DAY), now(), now(), now(), 7, 1000);



-- exercises
insert into exercises
    (name, numRepsOrDuration, numSets, assignedFrequency, assignedDuration, dateAssigned, ptNotes, mediaUrl, createdAt, updatedAt, patientId, streak)
values
    ('shoulder extension', 12, 3, 5, null, now(), 'extend shoulder while laying on side', null, now(), now(), 1, 5),
    ('shoulder flexion', 12, 3, 5, null, now(), 'flex shoulder while laying on side', null, now(), now(), 1, 23),
    ('stubbed toe extension', 12, 3, 5, null, now(), 'flex toe while laying on roof of building', null, now(), now(), 2, 54),
    ('stubbed toe flexion', 12, 3, 5, null, now(), 'flex toe while laying upside down', null, now(), now(), 2, 1),
    ('stubbed toe flexion', 12, 3, 5, null, now(), 'flex toe while laying upside down', null, now(), now(), 2, 4),
    ('sprained ankle flexion', 12, 3, 5, null, now(), 'flex ankle while laying on bed of rocks', null, now(), now(), 3, 77),
    ('sprained ankle movement', 12, 3, 5, null, now(), 'flex ankle while laying on roof of car', null, now(), now(), 3, 343);

-- exerciseCompletions
insert into exerciseCompletions
    (painInput, createdAt, updatedAt, exerciseId)
values
    (1, now(), now(), 1),
    (1, now(), now(), 1),
    (1, now(), now(), 1),
    (1, now(), now(), 1),
    (2, now(), now(), 1),
    (2, now(), now(), 1),
    (2, now(), now(), 1),
    (2, now(), now(), 1),
    (2, now(), now(), 1),
    (2, now(), now(), 4),
    (2, now(), now(), 4),
    (2, now(), now(), 4),
    (2, now(), now(), 4),
    (2, now(), now(), 1);