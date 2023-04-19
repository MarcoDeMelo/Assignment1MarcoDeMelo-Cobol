       IDENTIFICATION DIVISION.
       PROGRAM-ID. Assignment1MarcoDeMelo.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT F01-INPUT-FILE ASSIGN TO "CodingAsst.dat"
       ORGANIZATION IS LINE SEQUENTIAL.
       SELECT F01-OUTPUT-FILE ASSIGN TO "UniReport.dat"
       ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD F01-INPUT-FILE
       RECORD CONTAINS 70 CHARACTERS
       DATA RECORD IS F01-STUDENT-RECORD.
       01 F01-STUDENT-RECORD.
         05 F01-STUDENT-ID PIC X(5).
         05 F02-COURSE-CODE-1 PIC X(7).
         05 F02-GRADE-1 PIC X.
         05 F03-COURSE-CODE-2 PIC X(7).
         05 F03-GRADE-2 PIC X.
         05 F04-COURSE-CODE-3 PIC X(7).
         05 F04-GRADE-3 PIC X.
         05 F05-COURSE-CODE-4 PIC X(7).
         05 F05-GRADE-4 PIC X.
         05 F06-COURSE-CODE-5 PIC X(7).
         05 F06-GRADE-5 PIC X.
         05 F07-COURSE-CODE-6 PIC X(7).
         05 F07-GRADE-6 PIC X.
       FD F01-OUTPUT-FILE
       RECORD CONTAINS 57 CHARACTERS
       DATA RECORD IS F02-OUTPUT-FILE.
       01 F02-OUTPUT-FILE PIC X(57).
       WORKING-STORAGE SECTION.
       01 W01-TITTLE.
         05 PIC X(10) VALUE SPACES.
         05 PIC X(34) VALUE "UNIVERSITY OF NOTHING BY MARCO DE MELO".
       01 W02-TITTLE.
         05 PIC X(14) VALUE SPACES.
         05 PIC X(29) VALUE "STUDENT CURRICULUM EVALUATION".
       01 W03-HEADING1.
         05 PIC X(10) VALUE "STUDENT ID".
         05 PIC X(20) VALUE SPACES.
         05 PIC X(23) VALUE "PERCENTAGE OF COURSES".
       01 W04-HEADING2.
         05 PIC X(2) VALUE SPACES.
         05 PIC X(6) VALUE "NUMBER".
         05 PIC X(3) VALUE SPACES.
         05 PIC X(9) VALUE "COMPLETED".
         05 PIC X(3) VALUE SPACES.
         05 PIC X(9) VALUE "REMAINING".
         05 PIC X(2) VALUE SPACES.
         05 PIC X(23) VALUE "TRANSFERRED PROFICIENCY".
       01 W05-REPORT.
         05 PIC X(2) VALUE SPACES.
         05 W0S-STUDENT-ID PIC X(5).
         05 PIC X(4) VALUE SPACES.
         05 W0S-COMPLETED PIC 999.
         05 PIC X(9) VALUE SPACES.
         05 W0S-REMAINING PIC 999.
         05 PIC X(9) VALUE SPACES.
         05 W0S-TRANSFERED PIC 999.
         05 PIC X(9) VALUE SPACES.
         05 W0S-PROFICIENCY PIC 999.
       01 W0S-TOTAL-COURSES PIC 999.
       01 W0S-COURSE-CODE PIC X(7).
       01 W0S-GRADE PIC X.
       01 W0S-SWITCH PIC X(2).
       01 W0S-PROFICIENCY-COURSE PIC 999.
       01 W0S-TRANSFERED-COURSE PIC 999.
       01 W0S-REMAINING-COURSE PIC 999.
       01 W0S-COMPLETED-COURSE PIC 999.
       PROCEDURE DIVISION.
           PERFORM 100-OPEN-FILES
           PERFORM 200-PRINT-HEADINGS
           PERFORM UNTIL W0S-SWITCH = 'NO'
               PERFORM 300-PROCESS-RECORDS
           END-PERFORM
           PERFORM 400-CLOSE-FILE
           STOP RUN.

       100-OPEN-FILES.
           OPEN INPUT F01-INPUT-FILE
           OPEN OUTPUT F01-OUTPUT-FILE
           DISPLAY "FILES OPENED".

       200-PRINT-HEADINGS.
           WRITE F02-OUTPUT-FILE FROM W01-TITTLE
           WRITE F02-OUTPUT-FILE FROM W02-TITTLE
           WRITE F02-OUTPUT-FILE FROM SPACES
           WRITE F02-OUTPUT-FILE FROM W03-HEADING1
           WRITE F02-OUTPUT-FILE FROM W04-HEADING2.

       300-PROCESS-RECORDS.
           READ F01-INPUT-FILE
               AT END
                   MOVE 'NO' TO W0S-SWITCH
               NOT AT END
                   MOVE F01-STUDENT-ID TO W0S-STUDENT-ID
                   PERFORM 310-CHECK-ALL-GRADES
                   PERFORM 320-CALCULATE-PERCENTAGES
                   WRITE F02-OUTPUT-FILE FROM W05-REPORT
                   PERFORM 330-CLEAR-TOTALS
           END-READ.

       310-CHECK-ALL-GRADES.
           MOVE F02-COURSE-CODE-1 TO W0S-COURSE-CODE
           MOVE F02-GRADE-1 TO W0S-GRADE
           PERFORM 312-CHECK-ONE-GRADE
           MOVE F03-COURSE-CODE-2 TO W0S-COURSE-CODE
           MOVE F03-GRADE-2 TO W0S-GRADE
           PERFORM 312-CHECK-ONE-GRADE
           MOVE F04-COURSE-CODE-3 TO W0S-COURSE-CODE
           MOVE F04-GRADE-3 TO W0S-GRADE
           PERFORM 312-CHECK-ONE-GRADE
           MOVE F05-COURSE-CODE-4 TO W0S-COURSE-CODE
           MOVE F05-GRADE-4 TO W0S-GRADE
           PERFORM 312-CHECK-ONE-GRADE
           MOVE F06-COURSE-CODE-5 TO W0S-COURSE-CODE.
           MOVE F06-GRADE-5 TO W0S-GRADE
           PERFORM 312-CHECK-ONE-GRADE
           MOVE F07-COURSE-CODE-6 TO W0S-COURSE-CODE
           MOVE F07-GRADE-6 TO W0S-GRADE
           PERFORM 312-CHECK-ONE-GRADE.
       312-CHECK-ONE-GRADE.
           IF W0S-COURSE-CODE IS NOT = SPACE
               ADD 1 TO W0S-TOTAL-COURSES
           END-IF
           IF W0S-GRADE = "P"
               ADD 1 TO W0S-PROFICIENCY-COURSE
           END-IF
           IF W0S-GRADE = "K"
               ADD 1 TO W0S-TRANSFERED-COURSE
           END-IF

           IF W0S-GRADE = "A" OR "B" OR "C" OR "D" OR "P" OR "K"
               ADD 1 TO W0S-COMPLETED-COURSE
           END-IF
           IF W0S-GRADE = "F"
               ADD 1 TO W0S-REMAINING-COURSE
           END-IF.
      
       320-CALCULATE-PERCENTAGES.
           COMPUTE W0S-COMPLETED ROUNDED = W0S-COMPLETED-COURSE /
             W0S-TOTAL-COURSES * 100
           COMPUTE W0S-REMAINING ROUNDED = (W0S-TOTAL-COURSES - W0S-COMPLETED-COURSE) /
             W0S-TOTAL-COURSES * 100
           COMPUTE W0S-TRANSFERED ROUNDED = W0S-TRANSFERED-COURSE /
             W0S-TOTAL-COURSES * 100
           COMPUTE W0S-PROFICIENCY ROUNDED = W0S-PROFICIENCY-COURSE /
             W0S-TOTAL-COURSES * 100.
       330-CLEAR-TOTALS.
           MOVE ZERO TO W0S-TOTAL-COURSES
           MOVE ZERO TO W0S-COMPLETED-COURSE
           MOVE ZERO TO W0S-REMAINING-COURSE
           MOVE ZERO TO W0S-TRANSFERED-COURSE
           MOVE ZERO TO W0S-PROFICIENCY-COURSE.
       400-CLOSE-FILE.
           CLOSE F01-INPUT-FILE
           CLOSE F01-OUTPUT-FILE
           DISPLAY "FILES CLOSED".

