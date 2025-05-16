(define (problem problem0_5)
    (:domain warehouse)
    (:objects
        mover1 mover2 - mover
        loader1 - loader
        loader2 - cheapLoader
        loc1 loc2 loading-bay - location
        crate1 crate2 - crate
        groupA - group
    )
    
    (:init
        (at-robby mover1 loading-bay)
        (at-robby mover2 loading-bay)
        (at-robby loader1 loading-bay)
        (at-robby loader2 loading-bay)
        
        (= (battery-status mover1) 20)
        (= (battery-status mover2) 20)
        
        (at-crate crate1 loc1)
        (at-crate crate2 loc2)

        (has-no-group crate1)

        (is-of-group crate2 groupA)
        
        (free mover1)
        (free mover2)
        (free loader1)
        (free loader2)
        
        (is-bay loading-bay)
        (no-active-group)

        (= (crates-to-load groupA) 1)
        (= (crates-at-bay loading-bay) 0)
        
        (= (distance loc1 loading-bay) 10)
        (= (distance loading-bay loc1) 10)
        (= (distance loc2 loading-bay) 20)
        (= (distance loading-bay loc2) 20)
        
        (= (weight crate1) 70)
        (= (weight crate2) 20)

               
        (= (is-fragile crate1) 0)
        (= (is-fragile crate2) 0)
    )
    
    (:goal
        (and (loaded crate1) (loaded crate2))
    )
    
    (:metric minimize (total-time))
)