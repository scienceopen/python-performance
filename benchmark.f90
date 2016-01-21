program benchrandmult
    Implicit None
    
    integer, parameter ::  dp = kind(0.d0)
    integer, parameter :: i64 = selected_int_kind(18) ! At least 64-bit integer
    
    real(dp) :: sysclock2ms
    integer :: k
    integer(i64) :: tic,toc,tmin
    
    integer,parameter :: N=500
    real(dp) :: A(N,N), B(N,N)

    Integer, parameter :: Nrun=1000
    
    !real(dp),allocatable:: e(:,:)
    real(dp) :: d(N,N),e(N,N)

!    print *,'init random seed'
    call init_random_seed()
!    print *,'fill matrices'

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming loop'
    ! recommended to call once before loop per Intel manual
    call dgemm('N','N',N,N,N,1.d0,A,N,B,N,1.d0,d,N)
    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)
        
        d=0.d0 !necessary for DGEMM
        
        call system_clock(tic)
        call dgemm('N','N',N,N,N,1.d0,A,N,B,N,1.d0,d,N)
        !e = matmul(A,B)
        call system_clock(toc)
        
        if (toc-tic<tmin) tmin=toc-tic
        !print *,real(k)/Nrun*100.
        !print *,d(2,1),e(2,1)
    end do

    tmin = toc-tic
    
    !deallocate(e)

print "('fortran milliseconds per matmul ',f0.6)", sysclock2ms(tmin) 

end program

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

! Convert a number of clock ticks, as returned by system_clock called
! with integer(i64) arguments, to milliseconds
function sysclock2ms(t)
    integer, parameter ::  dp = kind(0.d0)
    integer, parameter :: i64 = selected_int_kind(18) ! At least 64-bit integer
    
  integer(i64), intent(in) :: t
  integer(i64) :: rate
  real(dp) ::  sysclock2ms,r
  call system_clock(count_rate=rate)
  r = 1000._dp / rate
  sysclock2ms = t * r
end function sysclock2ms

subroutine init_random_seed()
integer :: i, n, clock
integer, allocatable :: seed(:)
call random_seed(size=n)
allocate(seed(n))
call system_clock(count=clock)
seed = clock + 37 * [ (i - 1, i = 1, n) ]
call random_seed(put=seed)
end subroutine
