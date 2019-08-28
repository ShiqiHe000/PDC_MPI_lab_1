PROGRAM search  
        use mpi
  implicit none
  integer, parameter ::  N=300
  integer i, target ! local variables
  integer b(N)      ! the entire array of integers
  integer :: rank, proc, ierror
  integer :: my_start, my_end, my_n
  character(len=4) :: rankchar
  character(len=15) :: outfilename

 
        call mpi_init(ierror)
        call mpi_comm_rank(mpi_comm_world, rank, ierror)
        call mpi_comm_size(mpi_comm_world, proc, ierror)



  ! File b.data has the target value on the first line
  ! The remaining 300 lines of b.data have the values for the b array
  if(rank == 0) then
        open(unit=10,file="b.data")     
  
!  ! File found.data will contain the indices of b where the target is
 ! open(unit=11,file="found.data")

        ! Read in the target
        read(10,*) target
  
  ! Read in b array 

  do i=1,N
     read(10,*) b(i)
  end do
  
  endif

        ! bcast the target
        call MPI_BCAST(target, 1, mpi_integer, 0, mpi_comm_world, IERROR)
        call mpi_bcast(b, n, mpi_integer, 0, mpi_comm_world, ierror)


  ! Search the b array and output the target locations
  my_n = n/proc
  my_start = rank*my_n+1
  my_end = (rank+1)*my_n

  if(rank==proc-1) then
        if(real(n/proc) /= 0.0) then
                my_end = n
        endif
  endif

  write(rankchar,'(i4.4)') rank
  outfilename="found.data_" // rankchar
  open(unit=11,file=outfilename)


  do i=my_start, my_end
     if (b(i) == target) then
        write(11,*) i
     end if
  end do

  close(unit = 11)
  
        call mpi_finalize(ierror)

END PROGRAM search 
