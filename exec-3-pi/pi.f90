program pi
        use mpi
        implicit none

        integer, parameter :: DARTS = 50000, ROUNDS = 10, MASTER = 0

        real(8) :: pi_est
        real(8) :: homepi, avepi, pirecv, pisum
        integer :: rank
        integer :: i, n
        integer, allocatable :: seed(:)
        integer :: ierror
        integer :: proc
        integer :: my_darts
        real(8) :: pi_sum

!
        ! we set it to zero in the sequential run
        
        call mpi_init(ierror)
        call mpi_comm_rank(mpi_comm_world, rank, ierror)
        call mpi_comm_size(mpi_comm_world, proc, ierror)
        
        ! initialize the random number generator
        ! we make sure the seed is different for each task
        call random_seed()
        call random_seed(size = n)
        allocate(seed(n))
        seed = 12 + rank*11
        call random_seed(put=seed(1:n))
        deallocate(seed)
        
!        pi_sum = 0.0d0
        avepi = 0.0d0
        pi_est = 0.0d0

        my_darts = darts/proc

              if(rank == 0) then
                if(real(darts/proc) /= 0.0 ) then
                        my_darts = darts - (proc-1)*my_darts
                endif
              endif

        do i = 0, ROUNDS-1
!        do i=0, 0

        pi_est = dboard(my_darts)
                
        pi_sum = 0.0d0
        call MPI_REDUCE(pi_est, pi_sum, 1, mpi_double_precision, mpi_sum, master, &
                mpi_comm_world, IERROR)
        

           ! calculate the average value of pi over all iterations
           if(rank == 0) then
           
           pi_sum = pi_sum/proc

           avepi = ((avepi*i) + pi_sum)/(i + 1)

        
           print *, "After ", DARTS*(i+1), " throws, average value of pi =", avepi
           endif
                
        call mpi_barrier(mpi_comm_world, ierror)

!           call mpi_finalize(ierror)
        
!           if(rank == 0) then 
!        print *, "avepi=", avepi
!           endif

        end do
        


        call mpi_finalize(ierror)

        contains
        
           real(8) function dboard(my_darts)
        
              integer, intent(in) :: my_darts
        
              real(8) :: x_coord, y_coord
              integer :: score, n



              score = 0.0d0
              do n = 1, my_darts
                 call random_number(x_coord)
                 call random_number(y_coord)
        
                 if ((x_coord**2 + y_coord**2) <= 1.0d0) then
                    score = score + 1
                 end if
              enddo
!print *, "score=", score, "rank=", rank
 !call mpi_barrier(mpi_comm_world, ierror)
              dboard = 4.0d0*score/my_darts
                
                

           end function

end program

