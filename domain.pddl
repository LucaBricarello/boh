(define (domain warehouse)
    (:requirements
        :strips
        :duration-inequalities
        :durative-actions
        :equality
        :numeric-fluents
        :object-fluents
        :typing
    )

    (:types mover loader cheapLoader - robot 
            location 
            crate 
            group)

    (:predicates 
        (at-robby ?r - robot ?loc - location)
        (at-crate ?c - crate ?loc - location)
        (free ?r - robot)
        (loaded ?c - crate)
        (is-bay ?loc - location)
        (is-of-group ?c - crate ?g - group)
        (no-active-group)
        (active-group ?g - group)
        (has-no-group ?c - crate)
    )

    (:functions
        (distance ?from ?to - location)
        (weight ?c - crate)
        (crates-to-load ?g - group)
        (is-fragile ?c - crate)                 ;0 not, 1 yes. We can't use a predicate because OPTIC doesn't support negative preconditions
        (battery-status ?m - mover)
        (crates-at-bay ?loc - location)   
    )

    
    ; ----------------------------------------------------------------------------------------------------------
    ; MOVER RECHARGE

    (:durative-action recharge
        :parameters (?m - mover ?loc - location)
        :duration   (and (>= ?duration 0) (<= ?duration 20)) 
        :condition  (and 
                        (at start (is-bay ?loc))  
                        (at start (at-robby ?m ?loc))
                        (at start (< (battery-status ?m) 20))
                    )
        :effect (and
                    ;(increase (battery-status ?m) (* ?duration 1)) 
                    ; charge rate = 1
                    (increase (battery-status ?m) (* #t 1))
                )
    )


    

    ; ----------------------------------------------------------------------------------------------------------
    ; MOVE WITHOUT CRATE

    (:durative-action move-empty
        :parameters (?m - mover ?from ?to - location)
        :duration   (= ?duration (/ (distance ?from ?to) 10))
        :condition  (and
                        (at start (free ?m))
                        (at start (at-robby ?m ?from))
                        (at start (>= (battery-status ?m) (/ (distance ?from ?to) 10)))     ; Check that battery is enough at the start
                    )
        :effect (and
                    (at start (not (at-robby ?m ?from)))
                    (at end (at-robby ?m ?to))
                    (at end (decrease (battery-status ?m) (/ (distance ?from ?to) 10)))     ; Decrease the battery in one-shot at the end
                )
    )


    ; ----------------------------------------------------------------------------------------------------------
    ; MOVE WITH EACH TYPE OF CRATE (PICK UP AND DROP INCLUDED)
    ; Sono tutte delle MACRO di pick-up, move e drop

    (:durative-action move-light 
        :parameters (?c - crate ?m - mover ?from ?to - location)
        :duration   (= ?duration (/ (* (distance ?from ?to) (weight ?c)) 100))
        :condition  (and 
                        (at start (free ?m))
                        (at start (at-crate ?c ?from))
                        (at start (at-robby ?m ?from))
                        (at start (is-bay ?to))
                        (at end (< (crates-at-bay ?to) 3))
                        (at start (= (is-fragile ?c) 0))
                        (at start (<= (weight ?c) 50))
                        (at start (>= (battery-status ?m) (/ (* (distance ?from ?to) (weight ?c)) 100)))
                    )
        :effect (and 
                    (at start (not (free ?m)))
                    (at start (not (at-robby ?m ?from)))
                    (at start (not (at-crate ?c ?from)))
                    (at end (free ?m))
                    (at end (at-robby ?m ?to))
                    (at end (at-crate ?c ?to))
                    (at end (increase (crates-at-bay ?to) 1))
                    (at end (decrease (battery-status ?m) (/ (* (distance ?from ?to) (weight ?c)) 100)))
                )
    )

    
    (:durative-action move-light-both 
        :parameters (?c - crate ?m1 ?m2 - mover ?from ?to - location)
        :duration   (= ?duration (/ (* (distance ?from ?to) (weight ?c)) 150))
        :condition  (and 
                        (at start (free ?m1))
                        (at start (free ?m2))
                        (at start (at-crate ?c ?from))
                        (at start (at-robby ?m1 ?from))
                        (at start (at-robby ?m2 ?from))
                        (at start (is-bay ?to))
                        (at end (< (crates-at-bay ?to) 3))
                        (at start (<= (weight ?c) 50))
                        (at start (>= (battery-status ?m1) (/ (* (distance ?from ?to) (weight ?c)) 150)))
                        (at start (>= (battery-status ?m2) (/ (* (distance ?from ?to) (weight ?c)) 150)))
                    )
        :effect (and 
                    (at start (not (free ?m1)))
                    (at start (not (free ?m2)))
                    (at start (not (at-robby ?m1 ?from)))
                    (at start (not (at-robby ?m2 ?from)))
                    (at start (not (at-crate ?c ?from)))
                    (at end (free ?m1))
                    (at end (free ?m2))
                    (at end (at-robby ?m1 ?to))
                    (at end (at-robby ?m2 ?to))
                    (at end (at-crate ?c ?to))
                    (at end (increase (crates-at-bay ?to) 1))
                    (at end (decrease (battery-status ?m1) (/ (* (distance ?from ?to) (weight ?c)) 150)))
                    (at end (decrease (battery-status ?m2) (/ (* (distance ?from ?to) (weight ?c)) 150)))
                )
    )
    
    (:durative-action move-heavy 
        :parameters (?c - crate ?l - loader ?m1 ?m2 - mover ?from ?to - location)
        :duration   (= ?duration (/ (* (distance ?from ?to) (weight ?c)) 100))
        :condition  (and 
                        (at start (free ?m1))
                        (at start (free ?m2))
                        (at start (at-crate ?c ?from))
                        (at start (at-robby ?m1 ?from))
                        (at start (at-robby ?m2 ?from))
                        (at start (is-bay ?to))
                        (at end (< (crates-at-bay ?to) 3))
                        (at start (> (weight ?c) 50))
                        (at end (free ?l))
                        (at start (>= (battery-status ?m1) (/ (* (distance ?from ?to) (weight ?c)) 100)))
                        (at start (>= (battery-status ?m2) (/ (* (distance ?from ?to) (weight ?c)) 100)))
                    )
        :effect (and 
                    (at start (not (free ?m1)))
                    (at start (not (free ?m2)))
                    (at start (not (at-robby ?m1 ?from)))
                    (at start (not (at-robby ?m2 ?from)))
                    (at start (not (at-crate ?c ?from)))
                    (at end (free ?m1))
                    (at end (free ?m2))
                    (at end (at-robby ?m1 ?to))
                    (at end (at-robby ?m2 ?to))
                    (at end (at-crate ?c ?to))
                    (at end (increase (crates-at-bay ?to) 1))
                    (at end (decrease (battery-status ?m1) (/ (* (distance ?from ?to) (weight ?c)) 100)))
                    (at end (decrease (battery-status ?m2) (/ (* (distance ?from ?to) (weight ?c)) 100)))
                )
    )


    ; ----------------------------------------------------------------------------------------------------------
    ; GROUP ACTIVATION AND DEACTIVATION
    ; FATTO

    (:action activate_group
        :parameters (?g - group)
        :precondition   (and 
                            (> (crates-to-load ?g) 0) 
                            (no-active-group)
                        )
        :effect (and 
                    (active-group ?g) 
                    (not (no-active-group))
                )
    )
    
    (:action deactivate_group
        :parameters (?g - group)
        :precondition   (and 
                            (= (crates-to-load ?g) 0) 
                            (active-group ?g)
                        )
        :effect (and 
                    (no-active-group) 
                    (not (active-group ?g))
                )
    )

    ; ----------------------------------------------------------------------------------------------------------
    ; LOAD NORMAL CRATE (GROUP AND NO GROUP)
    ; FATTO

    (:durative-action load-crate
        :parameters (?c - crate ?l - loader ?loc - location)
        :duration   (= ?duration 4)
        :condition  (and 
                        (at start (at-crate ?c ?loc))
                        (at start (is-bay ?loc))
                        (at start (= (is-fragile ?c) 0))
                        (at start (free ?l))
                        (at start (no-active-group))
                        (at start (has-no-group ?c))
                    )
        :effect (and 
                    (at start (not (at-crate ?c ?loc)))
                    (at start (not (free ?l)))
                    (at end (free ?l))
                    (at end (decrease (crates-at-bay ?loc) 1))
                    (at end (loaded ?c))                    
                )
    )

    (:durative-action load-crate-of-group
        :parameters (?c - crate ?l - loader ?loc - location ?g - group)
        :duration   (= ?duration 4)
        :condition  (and 
                        (at start (at-crate ?c ?loc))
                        (at start (is-bay ?loc))
                        (at start (= (is-fragile ?c) 0))
                        (at start (free ?l))
                        (at start (active-group ?g))
                        (at start (is-of-group ?c ?g))
                    )
        :effect (and 
                    (at start (not (at-crate ?c ?loc)))
                    (at start (not (free ?l)))
                    (at end (free ?l))
                    (at end (decrease (crates-at-bay ?loc) 1))
                    (at end (loaded ?c))
                    (at end (decrease (crates-to-load ?g) 1))
                )
    )

    ; ----------------------------------------------------------------------------------------------------------
    ; LOAD FRAGILE CRATE (GROUP AND NO GROUP)
    ; FATTO

    (:durative-action load-fragile-crate
        :parameters (?c - crate ?l - loader ?loc - location)
        :duration   (= ?duration 6)
        :condition  (and 
                        (at start (at-crate ?c ?loc))
                        (at start (is-bay ?loc))
                        (at start (free ?l))
                        (at start (= (is-fragile ?c) 1))
                        (at start (no-active-group))
                        (at start (has-no-group ?c))
                    )
        :effect (and 
                    (at start (not (at-crate ?c ?loc)))
                    (at start (not (free ?l)))
                    (at end (free ?l))
                    (at end (decrease (crates-at-bay ?loc) 1))
                    (at end (loaded ?c))
                )
    )

    (:durative-action load-fragile-crate-of-group
        :parameters (?c - crate ?l - loader ?loc - location ?g - group)
        :duration   (= ?duration 6)
        :condition  (and 
                        (at start (at-crate ?c ?loc))
                        (at start (is-bay ?loc))
                        (at start (free ?l))
                        (at start (= (is-fragile ?c) 1))
                        (at start (active-group ?g))
                        (at start (is-of-group ?c ?g))
                    )
        :effect (and 
                    (at start (not (at-crate ?c ?loc)))
                    (at start (not (free ?l)))
                    (at end (free ?l))
                    (at end (decrease (crates-at-bay ?loc) 1))
                    (at end (loaded ?c))
                    (at end (decrease (crates-to-load ?g) 1))
                )
    )

    ; ----------------------------------------------------------------------------------------------------------
    ; CHEAP LOAD
    ; FATTO

    (:durative-action cheap-load-crate
        :parameters (?c - crate ?cl - cheapLoader ?loc - location)
        :duration   (= ?duration 4)
        :condition  (and 
                        (at start (at-crate ?c ?loc))
                        (at start (is-bay ?loc))
                        (at start (= (is-fragile ?c) 0))
                        (at start (free ?cl))
                        (at start (no-active-group))
                        (at start (has-no-group ?c))
                        (at start (<= (weight ?c) 50)) 
                    )
        :effect (and 
                    (at start (not (at-crate ?c ?loc)))
                    (at start (not (free ?cl)))
                    (at end (free ?cl))
                    (at end (decrease (crates-at-bay ?loc) 1))
                    (at end (loaded ?c))
                )
    )

    (:durative-action load-crate-cheap-group
        :parameters (?c - crate ?cl - cheapLoader ?loc - location ?g - group) ;
        :duration   (= ?duration 4)
        :condition  (and 
                        (at start (at-crate ?c ?loc))
                        (at start (is-bay ?loc))
                        (at start (= (is-fragile ?c) 0))
                        (at start (free ?cl))
                        (at start (<= (weight ?c) 50)) ;
                        (at start (active-group ?g))
                        (at start (is-of-group ?c ?g))
                    )                    
        :effect (and 
                    (at start (not (at-crate ?c ?loc)))
                    (at start (not (free ?cl)))
                    (at end (free ?cl))
                    (at end (decrease (crates-at-bay ?loc) 1))
                    (at end (loaded ?c))
                    (at end (decrease (crates-to-load ?g) 1))
                )
    )

    (:durative-action load-crate-cheap-fragile
        :parameters (?c - crate ?cl - cheapLoader ?loc - location) ;
        :duration   (= ?duration 6)
        :condition  (and 
                        (at start (at-crate ?c ?loc))
                        (at start (is-bay ?loc))
                        (at start (free ?cl))
                        (at start (no-active-group))
                        (at start (has-no-group ?c))
                        (at start (<= (weight ?c) 50)) ;
                        (at start (= (is-fragile ?c) 1))
                    )                    
        :effect (and 
                    (at start (not (at-crate ?c ?loc)))
                    (at start (not (free ?cl)))
                    (at end (free ?cl))
                    (at end (decrease (crates-at-bay ?loc) 1))
                    (at end (loaded ?c))
                )
    )

    (:durative-action load-crate-cheap-group-fragile
        :parameters (?c - crate ?cl - cheapLoader ?loc - location ?g - group) ;
        :duration   (= ?duration 6)
        :condition  (and 
                        (at start (at-crate ?c ?loc))
                        (at start (is-bay ?loc))
                        (at start (free ?cl))
                        (at start (<= (weight ?c) 50)) ;
                        (at start (active-group ?g))
                        (at start (is-of-group ?c ?g))
                        (at start (= (is-fragile ?c) 1))
                    )                    
        :effect (and 
                    (at start (not (at-crate ?c ?loc)))
                    (at start (not (free ?cl)))
                    (at end (free ?cl))
                    (at end (decrease (crates-at-bay ?loc) 1))
                    (at end (loaded ?c))
                    (at end (decrease (crates-to-load ?g) 1))
                )
    )
)
