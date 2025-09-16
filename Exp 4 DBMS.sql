-- hospital_management DCL + TCL lab script (REVISED numbering)
-- PURPOSE: A single numbered SQL sheet matching your assignment numbering.
-- IMPORTANT: DCL commands (1-12) include actions by root/admin and actions to test as the new user 'zaid'.
--            Where indicated, switch to the zaid session: mysql -u zaid -p -h localhost hospital_management
--            TCL commands (1-16) should be executed as the 'zaid' user (after appropriate grants).

/* ================================
   PART A — Dcl (Data Control Language) — 12 numbered steps
   NOTE: DCL 1 clubs DROP USER IF EXISTS with CREATE USER as requested.
   Run root/admin parts as root; run user-test parts in a separate session as 'zaid'.
   ================================ */

-- DCL 1) (root) Drop user if exists and create user 'zaid'@'localhost'
DROP USER IF EXISTS 'zaid'@'localhost';
CREATE USER 'zaid'@'localhost' IDENTIFIED BY 'zaid123';
-- (Optional) confirm creation
SELECT 'DCL1: user created' AS info;

-- DCL 2) (root) Show the default permissions/grants for the new user
SHOW GRANTS FOR 'zaid'@'localhost';
-- Expected: GRANT USAGE ON *.* TO 'zaid'@'localhost'

-- DCL 3) (root) Create the database and one table (if not present) and use it
USE hospital_management;

-- DCL 4) (root) Give SELECT permission on the Patient table to the new user
GRANT SELECT ON hospital_management.Patient TO 'zaid'@'localhost';
FLUSH PRIVILEGES;
SELECT 'DCL4: granted SELECT on Patient to zaid' AS info;

-- DCL 5) (zaid session) Try to INSERT into the Patient table and note the result
-- Switch to zaid in a NEW session now to run the two commands below:
-- mysql -u zaid -p -h localhost hospital_management
-- then run:
-- INSERT INTO Patient (Patient_ID, Name, Date_of_Birth, Gender, Contact_Info, Address)
-- VALUES (1001, 'Test_Insert_Fail', '2000-01-01', 'Male', 'fail@example.com', 'Nowhere');
-- Expected: ERROR 1142 (INSERT denied) because only SELECT granted.

-- DCL 6) (root) Give INSERT permission to the new user
GRANT INSERT ON hospital_management.Patient TO 'zaid'@'localhost';
FLUSH PRIVILEGES;
SELECT 'DCL6: granted INSERT' AS info;

-- DCL 7) (zaid session) Insert some values into the table (now allowed)
-- As zaid run something like:
-- INSERT INTO Patient (Patient_ID, Name, Date_of_Birth, Gender, Contact_Info, Address)
-- VALUES (1001, 'Aarav Patel', '2001-04-10', 'Male', 'aarav.patel@example.com', '21 New St, Mumbai');
-- and
-- INSERT INTO Patient (Patient_ID, Name, Date_of_Birth, Gender, Contact_Info, Address)
-- VALUES (1002, 'Isha Reddy', '1996-08-01', 'Female', 'isha.reddy@example.com', '7 Lake Rd, Pune');
-- Then run: SELECT * FROM Patient WHERE Patient_ID IN (1001,1002);

-- DCL 8) (zaid session) Display the table
-- In zaid session run: SELECT Patient_ID, Name, Date_of_Birth, Gender, Address FROM Patient ORDER BY Patient_ID LIMIT 20;
-- Note the inserted rows appear.

-- DCL 9) (zaid session) Try to UPDATE the table and note the result (before UPDATE privilege)
-- Run: UPDATE Patient SET Address = 'Changed Addr' WHERE Patient_ID = 1001;
-- Expected: ERROR 1142 (UPDATE denied) unless UPDATE was granted previously.

-- DCL 10) (root) Give UPDATE permission to the user
GRANT UPDATE ON hospital_management.Patient TO 'zaid'@'localhost';
FLUSH PRIVILEGES;
SELECT 'DCL10: granted UPDATE' AS info;

-- DCL 11) (root) Give ALL permission to user (demonstration; optional)
GRANT ALL PRIVILEGES ON hospital_management.Patient TO 'zaid'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'zaid'@'localhost';
-- Note: after this, zaid can SELECT, INSERT, UPDATE, DELETE, etc. on this table.

-- DCL 12) (root) Revoke UPDATE permission from user and then test update as zaid
REVOKE UPDATE ON hospital_management.Patient FROM 'zaid'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'zaid'@'localhost';
-- Now switch to zaid session and attempt:
-- UPDATE Patient SET Address = 'Should Fail After Revoke' WHERE Patient_ID = 1001;
-- Expected: UPDATE denied. Record the error and note the revoke worked.

/* ================================
   PART B — TCL (Transaction Control Language) — 16 numbered blocks
   These should be executed in the zaid session (after granting SELECT, INSERT, UPDATE, DELETE as needed).
   Before running the TCL block, run as root (once):
     GRANT SELECT, INSERT, UPDATE, DELETE ON hospital_management.Patient TO 'zaid'@'localhost';
     FLUSH PRIVILEGES;
   Then connect as zaid: mysql -u zaid -p hospital_management
   ================================ */

-- TCL 1) START TRANSACTION
START TRANSACTION; -- TCL 1

-- TCL 2) INSERT a temporary row (uncommitted)
INSERT INTO Patient (Patient_ID, Name, Date_of_Birth, Gender, Contact_Info, Address)
VALUES (1101, 'TCL_Temp1', '1990-01-01', 'Male', 'tcltemp1@example.com', '1101 Temp Lane'); -- TCL 2

-- TCL 3) SELECT to view intermediate/uncommitted state (visible in this session)
SELECT Patient_ID, Name, Address FROM Patient WHERE Patient_ID = 1101; -- TCL 3

-- TCL 4) UPDATE the temporary row (still uncommitted)
UPDATE Patient SET Address = 'Updated Temp Address' WHERE Patient_ID = 1101; -- TCL 4
SELECT Patient_ID, Name, Address FROM Patient WHERE Patient_ID = 1101; -- shows updated address

-- TCL 5) DELETE an existing row (uncommitted) — choose a safe existing Patient_ID
DELETE FROM Patient WHERE Patient_ID = 1; -- TCL 5 (this delete is inside transaction)

-- TCL 6) SELECT to inspect these changes before rollback/commit
SELECT Patient_ID, Name FROM Patient WHERE Patient_ID IN (1101,1); -- TCL 6

-- TCL 7) ROLLBACK the transaction (undo TCL 2-5)
ROLLBACK; -- TCL 7

-- TCL 8) SELECT to verify rollback took effect (1101 should not exist; Patient_ID=1 restored)
SELECT Patient_ID, Name FROM Patient WHERE Patient_ID IN (1101,1); -- TCL 8

-- TCL 9) START TRANSACTION; INSERT and then COMMIT (persist a row)
START TRANSACTION; -- TCL 9
INSERT INTO Patient (Patient_ID, Name, Date_of_Birth, Gender, Contact_Info, Address)
VALUES (1102, 'Committed_Patient', '1991-02-02', 'Female', 'committed@example.com', '1102 Commit Rd'); -- TCL 9
COMMIT; -- TCL 9

-- TCL 10) Verify the committed row persists
SELECT Patient_ID, Name FROM Patient WHERE Patient_ID = 1102; -- TCL 10

-- TCL 11) START TRANSACTION; INSERT then ROLLBACK (row should not persist)
START TRANSACTION; -- TCL 11
INSERT INTO Patient (Patient_ID, Name, Date_of_Birth, Gender, Contact_Info, Address)
VALUES (1103, 'Rolledback_Patient', '1992-03-03', 'Male', 'rb@example.com', '1103 Rollback Ave'); -- TCL 11
ROLLBACK; -- TCL 11

-- TCL 12) Verify rollback of the second insert
SELECT Patient_ID, Name FROM Patient WHERE Name = 'Rolledback_Patient'; -- TCL 12

-- TCL 13) START TRANSACTION; perform UPDATE then ROLLBACK (undo the update)
START TRANSACTION; -- TCL 13
UPDATE Patient SET Address = 'Temporary Address 13' WHERE Patient_ID = 1102; -- changes visible here only
SELECT Patient_ID, Name, Address FROM Patient WHERE Patient_ID = 1102; -- shows temp address
ROLLBACK; -- TCL 13
SELECT Patient_ID, Name, Address FROM Patient WHERE Patient_ID = 1102; -- shows original address

-- TCL 14) START TRANSACTION; perform DELETE then ROLLBACK (undo the delete)
START TRANSACTION; -- TCL 14
DELETE FROM Patient WHERE Patient_ID = 1102; -- delete inside tx
SELECT Patient_ID, Name FROM Patient WHERE Patient_ID = 1102; -- empty in this tx
ROLLBACK; -- TCL 14
SELECT Patient_ID, Name FROM Patient WHERE Patient_ID = 1102; -- row should be back

-- TCL 15) Demonstrate SAVEPOINT: create savepoint and ROLLBACK TO savepoint
START TRANSACTION; -- TCL 15
INSERT INTO Patient (Patient_ID, Name, Date_of_Birth, Gender, Contact_Info, Address)
VALUES (1104, 'Before_Savepoint', '1993-04-04', 'Female', 'bsp@example.com', '1104 Before SP'); -- before savepoint
SAVEPOINT sp_a; -- savepoint
-- actions after savepoint (these will be undone by ROLLBACK TO sp_a)
INSERT INTO Patient (Patient_ID, Name, Date_of_Birth, Gender, Contact_Info, Address)
VALUES (1105, 'After_Savepoint_Insert', '1994-05-05', 'Male', 'asp@example.com', '1105 After SP');
UPDATE Patient SET Address = 'Changed After SP' WHERE Patient_ID = 1102; -- temp update
DELETE FROM Patient WHERE Patient_ID = 1103; -- harmless if not present
-- inspect uncommitted changes
SELECT Patient_ID, Name, Address FROM Patient WHERE Patient_ID IN (1104,1105,1102,1103);
-- rollback to savepoint (undoes 1105 and the update/delete; keeps 1104)
ROLLBACK TO sp_a; -- TCL 15
SELECT Patient_ID, Name, Address FROM Patient WHERE Patient_ID IN (1104,1105,1102,1103);
-- commit the remainder (so Before_Savepoint persists)
COMMIT; -- TCL 15

-- TCL 16) Final verification: display the Patient table snapshot to record final state
SELECT * FROM Patient ORDER BY Patient_ID LIMIT 500; -- TCL 16

/* ================================
   End of revised numbered SQL sheet.

   Notes:
   - DCL steps 5, 7, 8, 9, 12 require you to switch to the zaid session to test behavior from the user's perspective.
   - TCL steps must be executed as zaid to show transaction isolation and rollback behavior from that user's session.
   - Patient_ID values used in this sheet (1001..1105) are chosen to avoid clashes with your original 1..20 rows; adjust if your table uses AUTO_INCREMENT.
   - If Patient_ID is AUTO_INCREMENT, omit Patient_ID column in INSERT statements and use only the other columns.

   Want this exported as a downloadable .sql file or a formatted PDF ready for submission? I can do that next.
   ================================ */
