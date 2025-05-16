(define (problem problem4)
    (:domain warehouse)
    (:objects
        mover1 mover2 - mover
        loader1 - loader
        loader2 - cheapLoader
        loc1 loc2 loc3 loading-bay - location
        crate1 crate2 crate3 crate4 crate5 crate6 - crate
        groupA groupB - group
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
        (at-crate crate3 loc1)
        (at-crate crate4 loc2)
        (at-crate crate5 loc3)
        (at-crate crate6 loc1)
        
        (has-no-group crate6)

        (is-of-group crate1 groupA)
        (is-of-group crate2 groupA)
        (is-of-group crate3 groupB)
        (is-of-group crate4 groupB)
        (is-of-group crate5 groupB)
        
        (free mover1)
        (free mover2)
        (free loader1)
        (free loader2)
        
        (is-bay loading-bay)
        (no-active-group)
        
        (= (crates-to-load groupA) 2)
        (= (crates-to-load groupB) 3)
        (= (crates-at-bay loading-bay) 0)
        
        (= (distance loc1 loading-bay) 10)
        (= (distance loading-bay loc1) 10)
        (= (distance loc2 loading-bay) 20)
        (= (distance loading-bay loc2) 20)
        (= (distance loc3 loading-bay) 30)
        (= (distance loading-bay loc3) 30)
        
        (= (weight crate1) 30)
        (= (weight crate2) 20)
        (= (weight crate3) 30)
        (= (weight crate4) 20)
        (= (weight crate5) 30)
        (= (weight crate6) 20)

        (= (is-fragile crate1) 0)
        (= (is-fragile crate2) 1)
        (= (is-fragile crate3) 1)
        (= (is-fragile crate4) 1)
        (= (is-fragile crate5) 1)
        (= (is-fragile crate6) 0)
    )
    
    (:goal
        (and (loaded crate1) (loaded crate2) (loaded crate3) 
             (loaded crate4) (loaded crate5) (loaded crate6))
    )
    
    (:metric minimize (total-time))
)