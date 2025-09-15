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
(10, 'Emergency', 'Building J')
(11, 'Ophthalmology', 'Building K'),
(12, 'ENT', 'Building L'),
(13, 'Nephrology', 'Building M'),
(14, 'Endocrinology', 'Building N'),
(15, 'Hematology', 'Building O'),
(16, 'Pulmonology', 'Building P'),
(17, 'Rheumatology', 'Building Q'),
(18, 'Psychiatry', 'Building R'),
(19, 'Rehabilitation', 'Building S'),
(20, 'Onco-Surgery', 'Building T');

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
(10, 'Ananya Sen', '2000-01-29', 'Female', 'ananya.sen@example.com', '66 River Side, Ahmedabad')
(11, 'Vikram Mehra',  '1992-06-01', 'Male',  'vikram.mehra@example.com', '9 Church St, Delhi'),
(12, 'Sanya Kapoor',  '1987-11-23', 'Female','sanya.kapoor@example.com', '77 MG Road, Pune'),
(13, 'Deepak Sharma', '1960-02-17', 'Male',  'deepak.sharma@example.com', '3 Gandhi St, Jaipur'),
(14, 'Laila Khan',    '2005-04-30', 'Female','laila.khan@example.com',    '12 Lotus Ave, Lucknow'),
(15, 'Tara Iyer',     '2010-09-12', 'Female','tara.iyer@example.com',     '55 Palm Blvd, Chennai'),
(16, 'Arman Sheikh',  '1998-12-05', 'Other', 'arman.sheikh@example.com',  '8 Hilltop, Kolkata'),
(17, 'Sunita Rao',    '1955-01-20', 'Female','sunita.rao@example.com',    '101 Old Town, Kochi'),
(18, 'Mohit Verma',   '1975-07-07', 'Male',  'mohit.verma@example.com',   '200 Rose Lane, Bangalore'),
(19, 'Nikhil Joshi',  '1982-03-03', 'Male',  'nikhil.joshi@example.com',  '44 Lake Road, Hyderabad'),
(20, 'Rhea Gupta',    '1999-08-19', 'Female','rhea.gupta@example.com',    '88 Riverwalk, Ahmedabad');

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
(10, 'Dr. Suresh Nair', 'Emergency Specialist', 18, 'suresh.nair@hospital.com', 10)
(11, 'Dr. Neelam Bhat',   'Ophthalmologist',           9,  'neelam.bhat@hospital.com',      11),
(12, 'Dr. Arjun Desai',   'ENT Specialist',           13, 'arjun.desai@hospital.com',      12),
(13, 'Dr. Meera Nair',    'Nephrologist',             16, 'meera.nair@hospital.com',       13),
(14, 'Dr. Sanjay Kulkarni','Endocrinologist',         14, 'sanjay.kulkarni@hospital.com',  14),
(15, 'Dr. Ritu Malhotra', 'Hematologist',              7, 'ritu.malhotra@hospital.com',    15),
(16, 'Dr. Prakash Singh', 'Pulmonologist',            18, 'prakash.singh@hospital.com',    16),
(17, 'Dr. Rekha Menon',   'Rheumatologist',           12, 'rekha.menon@hospital.com',      17),
(18, 'Dr. Amit Bose',     'Psychiatrist',             11, 'amit.bose@hospital.com',        18),
(19, 'Dr. Neeta Rao',     'Rehabilitation Specialist',10, 'neeta.rao@hospital.com',        19),
(20, 'Dr. Karan Mehra',   'Surgical Oncologist',      22, 'karan.mehra@hospital.com',      20);

-- Diagnoses (10 rows)
INSERT INTO Diagnosis (Diagnosis_ID, Date, Cancer_Type, Stage, Patient_ID, Doctor_ID) VALUES
(1,  '2023-03-10', 'Lung Cancer',                          'Stage II', 1, 1),
(2,  '2023-05-12', 'Breast Cancer',                        'Stage I',  2, 1),
(3,  '2023-06-18', 'Brain Tumor',                          'Stage III',3, 4),
(4,  '2023-07-22', 'Leukemia',                             'Stage II', 4, 1),
(5,  '2023-08-15', 'Colon Cancer',                         'Stage I',  5, 1),
(6,  '2023-09-05', 'Skin Cancer',                          'Stage II', 6, 7),
(7,  '2023-10-11', 'Stomach Cancer',                       'Stage III',7, 8),
(8,  '2023-11-02', 'Kidney Cancer',                        'Stage I',  8, 9),
(9,  '2023-12-14', 'Prostate Cancer',                      'Stage II', 9, 9),
(10, '2024-01-07', 'Thyroid Cancer',                       'Stage I',  10, 3)
(11, '2024-03-21', 'Ocular Melanoma',                     'Stage II', 11, 11),
(12, '2024-05-30', 'Laryngeal Cancer',                    'Stage I',  12, 12),
(13, '2024-07-14', 'Renal Cell Carcinoma',                'Stage II', 13, 13),
(14, '2024-08-22', 'Pancreatic Adenocarcinoma',           'Stage III',14, 20),
(15, '2024-09-10', 'Acute Lymphoblastic Leukemia',        'Stage II', 15, 15),
(16, '2024-10-05', 'Mesothelioma',                        'Stage III',16, 16),
(17, '2024-11-11', 'Osteosarcoma (Bone Sarcoma)',         'Stage II', 17, 6),  -- Dr. Anil Kapoor (Orthopedic Surgeon, ID 6)
(18, '2024-12-01', 'Brain Metastasis',                    'Stage IV', 18, 4),  -- Dr. Vikram Rao (Neurologist, ID 4)
(19, '2025-01-18', 'Esophageal Cancer',                   'Stage II', 19, 8),  -- Dr. Manish Gupta (Gastroenterologist, ID 8)
(20, '2025-03-03', 'Recurrent Breast Cancer',             'Stage III',20, 20);

COMMIT;

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
