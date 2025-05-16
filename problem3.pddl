(define (problem problem3)
    (:domain warehouse)
    (:objects
        mover1 mover2 - mover
        loader1 - loader
        loader2 - cheapLoader
        loc1 loc2 loc3 loading-bay - location
        crate1 crate2 crate3 crate4 - crate
        groupA - group
    )
    
    (:init
        (at-robby mover1 loading-bay)
        (at-robby mover2 loading-bay)
        (at-robby loader1 loading-bay)
        (at-robby loader2 loading-bay)
        
        (= (battery-status mover1) 20)
        (= (battery-status mover2) 20)
        
        (at-crate crate1 loc2)
        (at-crate crate2 loc2)
        (at-crate crate3 loc3)
        (at-crate crate4 loc1)

        (has-no-group crate4)

        (is-of-group crate1 groupA)
        (is-of-group crate2 groupA)
        (is-of-group crate3 groupA)
        
        (free mover1)
        (free mover2)
        (free loader1)
        (free loader2)
        
        (is-bay loading-bay)
        (no-active-group)

        (= (crates-to-load groupA) 3)
        (= (crates-at-bay loading-bay) 0)
        
        (= (distance loc1 loading-bay) 10)
        (= (distance loading-bay loc1) 10)
        (= (distance loc2 loading-bay) 20)
        (= (distance loading-bay loc2) 20)
        (= (distance loc3 loading-bay) 30)
        (= (distance loading-bay loc3) 30)
        
        (= (weight crate1) 70)
        (= (weight crate2) 80)
        (= (weight crate3) 60)
        (= (weight crate4) 30)

        (= (is-fragile crate1) 0)
        (= (is-fragile crate2) 1)
        (= (is-fragile crate3) 0)
        (= (is-fragile crate4) 0)
    )
    
    (:goal
        (and (loaded crate1) (loaded crate2) (loaded crate3) (loaded crate4))
    )
    
    (:metric minimize (total-time))
)