

PROGRAM SEND_DATA

        USE MPI
        IMPLICIT NONE

        INTEGER :: IERROR
        INTEGER :: RANK
        INTEGER :: PROC
        INTEGER :: I
        INTEGER :: DATA 
        INTEGER    STATUS(MPI_STATUS_SIZE)

        ! START MPI
        CALL MPI_INIT(IERROR)

        ! GET RANK NUMBER AND THE PROC NUM
        CALL MPI_COMM_RANK(MPI_COMM_WORLD, RANK, IERROR)
        CALL MPI_COMM_SIZE(MPI_COMM_WORLD, PROC, IERROR)
        
        ! ASSIGN DATA VALUE IN THE FIRST PROCESS
        IF(RANK == 0) THEN
                DATA = 123
                PRINT *, "PROC = ", PROC
        ENDIF

        ! SEND AND RECEIVE DATA
        DO I=1, PROC-1
                IF(RANK == I-1) THEN
                        CALL MPI_SEND(DATA, 1, MPI_INTEGER, &
                                RANK+1, I, MPI_COMM_WORLD, IERROR)
                ELSEIF(RANK == I) THEN
                        CALL MPI_RECV(DATA, 1, MPI_INTEGER, RANK-1, I, &
                                 MPI_COMM_WORLD, STATUS, IERROR)
                ENDIF

        ENDDO

        ! CHECK THE RESULT
        IF(RANK == PROC - 1) THEN
                PRINT *, "DATA SENT TO THE LAST PROCESSOR"
                PRINT *, "DATA = ", DATA
        ENDIF

        ! FINALIZE
        CALL MPI_FINALIZE(IERROR)

END PROGRAM SEND_DATA
