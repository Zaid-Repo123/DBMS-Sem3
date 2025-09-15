-- Hospital Management DB: create schema, tables, and insert sample data
-- Run as a single script

-- 1) Create database
DROP DATABASE IF EXISTS hospital_management;
CREATE DATABASE hospital_management;
USE hospital_management;

-- 2) Create tables (order: Department, Patient, Doctor, Diagnosis)
-- Department
CREATE TABLE Department (
    Department_ID INT NOT NULL PRIMARY KEY,
    Department_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

-- Patient
CREATE TABLE Patient (
    Patient_ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Date_of_Birth DATE,
    Gender ENUM('Male','Female','Other') DEFAULT 'Male',
    Contact_Info VARCHAR(255),
    Address VARCHAR(255)
);

-- Doctor (references Department)
CREATE TABLE Doctor (
    Doctor_ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Specialization VARCHAR(100),
    Years_of_Experience INT,
    Contact_Info VARCHAR(255),
    Department_ID INT,
    CONSTRAINT fk_doctor_department
      FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
      ON DELETE SET NULL
      ON UPDATE CASCADE
) ;

-- Diagnosis (references Patient and Doctor)
CREATE TABLE Diagnosis (
    Diagnosis_ID INT NOT NULL PRIMARY KEY,
    Date DATE,
    Cancer_Type VARCHAR(150),
    Stage VARCHAR(50),
    Patient_ID INT,
    Doctor_ID INT,
    CONSTRAINT fk_diag_patient
      FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT fk_diag_doctor
      FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
      ON DELETE SET NULL
      ON UPDATE CASCADE
) ;

-- 3) Insert data
-- Departments (10 rows)
INSERT INTO Department (Department_ID, Department_Name, Location) VALUES
(1, 'Oncology', 'Building A'),
(2, 'Radiology', 'Building B'),
(3, 'Cardiology', 'Building C'),
(4, 'Neurology', 'Building D'),
(5, 'Pediatrics', 'Building E'),
(6, 'Orthopedics', 'Building F'),
(7, 'Dermatology', 'Building G'),
(8, 'Gastroenterology', 'Building H'),
(9, 'Urology', 'Building I'),
(10, 'Emergency', 'Building J');

-- Patients (10 rows)
INSERT INTO Patient (Patient_ID, Name, Date_of_Birth, Gender, Contact_Info, Address) VALUES
(1, 'Arjun Singh', '1985-03-12', 'Male', 'arjun.singh@example.com', '45 MG Road, Delhi'),
(2, 'Neha Gupta', '1990-07-25', 'Female', 'neha.gupta@example.com', '22 Park Street, Mumbai'),
(3, 'Rahul Verma', '1978-11-05', 'Male', 'rahul.verma@example.com', '12 Lotus Lane, Bangalore'),
(4, 'Meera Iyer', '2002-02-14', 'Female', 'meera.iyer@example.com', '78 Green Park, Chennai'),
(5, 'Kabir Nair', '1965-09-30', 'Male', 'kabir.nair@example.com', '101 Palm Avenue, Kochi'),
(6, 'Sonia Desai', '1972-12-21', 'Female', 'sonia.desai@example.com', '56 Marine Drive, Mumbai'),
(7, 'Imran Khan', '1988-04-19', 'Male', 'imran.khan@example.com', '89 Lake View, Hyderabad'),
(8, 'Pooja Bhatia', '1995-10-10', 'Female', 'pooja.bhatia@example.com', '23 Rose Garden, Pune'),
(9, 'Ravi Malhotra', '1970-08-03', 'Male', 'ravi.malhotra@example.com', '14 Hill Road, Kolkata'),
(10, 'Ananya Sen', '2000-01-29', 'Female', 'ananya.sen@example.com', '66 River Side, Ahmedabad');

-- Doctors (10 rows)
INSERT INTO Doctor (Doctor_ID, Name, Specialization, Years_of_Experience, Contact_Info, Department_ID) VALUES
(1, 'Dr. Ayesha Khan', 'Oncologist', 10, 'ayesha.khan@hospital.com', 1),
(2, 'Dr. Rohan Mehta', 'Radiologist', 8, 'rohan.mehta@hospital.com', 2),
(3, 'Dr. Priya Sharma', 'Cardiologist', 12, 'priya.sharma@hospital.com', 3),
(4, 'Dr. Vikram Rao', 'Neurologist', 15, 'vikram.rao@hospital.com', 4),
(5, 'Dr. Sneha Patel', 'Pediatrician', 9, 'sneha.patel@hospital.com', 5),
(6, 'Dr. Anil Kapoor', 'Orthopedic Surgeon', 20, 'anil.kapoor@hospital.com', 6),
(7, 'Dr. Kavita Joshi', 'Dermatologist', 11, 'kavita.joshi@hospital.com', 7),
(8, 'Dr. Manish Gupta', 'Gastroenterologist', 14, 'manish.gupta@hospital.com', 8),
(9, 'Dr. Farah Sheikh', 'Urologist', 7, 'farah.sheikh@hospital.com', 9),
(10, 'Dr. Suresh Nair', 'Emergency Specialist', 18, 'suresh.nair@hospital.com', 10);

-- Diagnoses (10 rows)
INSERT INTO Diagnosis (Diagnosis_ID, Date, Cancer_Type, Stage, Patient_ID, Doctor_ID) VALUES
(1,  '2023-03-10', 'Lung Cancer',      'Stage II', 1, 1),
(2,  '2023-05-12', 'Breast Cancer',    'Stage I',  2, 1),
(3,  '2023-06-18', 'Brain Tumor',      'Stage III',3, 4),
(4,  '2023-07-22', 'Leukemia',         'Stage II', 4, 1),
(5,  '2023-08-15', 'Colon Cancer',     'Stage I',  5, 1),
(6,  '2023-09-05', 'Skin Cancer',      'Stage II', 6, 7),
(7,  '2023-10-11', 'Stomach Cancer',   'Stage III',7, 8),
(8,  '2023-11-02', 'Kidney Cancer',    'Stage I',  8, 9),
(9,  '2023-12-14', 'Prostate Cancer',  'Stage II', 9, 9),
(10, '2024-01-07', 'Thyroid Cancer',   'Stage I',  10, 3);

-- 4) Quick verification queries (optional)
-- SELECT COUNT(*) FROM Department;
-- SELECT COUNT(*) FROM Patient;
-- SELECT COUNT(*) FROM Doctor;
-- SELECT COUNT(*) FROM Diagnosis;
 SELECT d.Diagnosis_ID, d.Date, d.Cancer_Type, d.Stage, p.Name AS Patient_Name, doc.Name AS Doctor_Name
FROM Diagnosis d
JOIN Patient p ON d.Patient_ID = p.Patient_ID
JOIN Doctor doc ON d.Doctor_ID = doc.Doctor_ID
ORDER BY d.Diagnosis_ID;
