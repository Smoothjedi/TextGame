#lang racket
(require racket/list string-interpolation text-table)

(struct item (name visible) #:transparent)

(struct location (name description short-description items) #:transparent)

(struct inventory (items) #:transparent)

(struct game-state (current-location inventory num-actions visited-locations) #:transparent)

(define house-key (item 'house-key #f))
(define left-shoe (item 'left-shoe #f))
(define right-shoe (item 'right-shoe #t))
(define work-gloves (item 'work-gloves #t))

(define (update-state new-location new-inventory num-actions visited-locations)
  (game-state new-location new-inventory num-actions visited-locations))

(define (filter-items-by-name items name)
  (let ([filtered-list
         (filter (lambda (item) (equal? (item-name item) name)) items)])
    (if (empty? filtered-list)
        filtered-list
        (car filtered-list))
    )
  )
(define (get-visible-items items)
  (let ([filtered-list
         (filter (lambda (item) (item-visible item)) items)])
    filtered-list))

;; (define (contains-item? items name)
;;   (not (empty? (filter-items-by-name items name))))


(define (pick-up-item state target-item-name)
  (let* ([current-location (game-state-current-location state)]
         [current-inventory (game-state-inventory state)]
         [items-at-location (location-items current-location)]
         [item-symbol (string->symbol target-item-name)]
         [item-to-pick-up (filter-items-by-name items-at-location item-symbol)])
    (cond
      [(struct? item-to-pick-up)
       (let* (
              [new-inventory
               (inventory (cons item-to-pick-up (inventory-items current-inventory)))]
              [new-items-at-location (remove-item item-to-pick-up items-at-location)]
              [new-location
               (location
                (location-name current-location)
                (location-description current-location)
                (location-short-description current-location)
                new-items-at-location
                )]
              )
         (update-state
          new-location new-inventory
          (+ 1 (game-state-num-actions state))
          (game-state-visited-locations state)))]
      [else
       (displayln "Item not found at this location.")
       state])))

(define (drop-item state target-item-name)
  (let* ([current-location (game-state-current-location state)]
         [current-inventory (game-state-inventory state)]
         [items-at-location (location-items current-location)]
         [item-symbol (string->symbol target-item-name)]
         [item-to-drop (filter-items-by-name (inventory-items current-inventory) item-symbol)])
    (cond
      [(struct? item-to-drop)
       (let* (
              [new-inventory 
               (inventory (remove-item item-to-drop (inventory-items current-inventory)))]
              [new-items-at-location (cons item-to-drop items-at-location)]
              [new-location
               (location
                (location-name current-location)
                (location-description current-location)
                (location-short-description current-location)
                new-items-at-location
                )]
              )
         (update-state new-location new-inventory
                       (+ 1 (game-state-num-actions state))
                       (game-state-visited-locations state)))]
      [else
       (displayln "Item not found in inventory.")
       state])))

(define (check-win-condition state)
  (let* ([current-location (game-state-current-location state)]
         [current-inventory (game-state-inventory state)])
    (if (and (not (empty? (filter-items-by-name (inventory-items current-inventory) 'house-key)))
             (equal? (location-name current-location) "Your frontyard"))
        #t #f)))



(define (win-game)
  (displayln "Congratulations, you have the key to your house, and unlock the front door.")
  (displayln "You drink copius amounts of water and recover on the couch in the A/C!")
  (exit 0))

(define (get-health-status state)
  (let* ([number (game-state-num-actions state)])
    (cond
      [(> number 12)
       (displayln "You gave it your best, but it wasn't enough. You collapse, and everything goes dark.")
       (displayln "Perhaps your neighbor will find you, but I wouldn't count on it.")
       (exit 0)]
      [(> number 10)
       "You're so weak you can barely keep your head up. You need to hurry!"]
      [(> number 8)
       "Your head is pounding. You're not sure how much longer you can last out here."]
      [(> number 6)
       "You're feeling dizzy as it feels like the sun is cooking you alive."]
      [(> number 4)
       "You're feeling weaker, and starting to wonder if you'll ever see inside your house again."]
      [(> number 2)
       "The sun is beating down, and you're starting to feel worse."]
      [else
       "Although you feel weak, spirits are high."])
    

    )
  )

(define (move-location target-location state)
  (let* ([updated-state (update-state
                        target-location
                        (game-state-inventory state)
                        (+ 1 (game-state-num-actions state))
                        (game-state-visited-locations state))])
    (if (check-win-condition updated-state)
        (win-game)
        updated-state))
  )

(define (remove-item item items)
  (let ([filtered-list
         (remove item items)])
    filtered-list))

(define (search-current-location state)
  (let* ([current-location (game-state-current-location state)]
         [items-at-location (location-items current-location)]
         [current-inventory (game-state-inventory state)])    
    (cond
      [(and (equal? (location-name current-location) "Your sideyard")
            (not (equal? 3 (length(inventory-items current-inventory)))))
       (displayln "This area is too dangerous to search without gloves and shoes.")
       (newline)
       state]
      [(equal? 0 (traverse-items items-at-location 0))
       (displayln "Nothing new was found.")
       (newline)
       state]
      [else
       (newline)
       (let* ([new-items-at-location
               (map (lambda (new-item) (item (item-name new-item) #t)) items-at-location)]
              [new-location
               (location
                (location-name current-location)
                (location-description current-location)
                (location-short-description current-location)
                new-items-at-location
                )])
         (update-state new-location (game-state-inventory state)
                       (+ 1 (game-state-num-actions state))
                       (game-state-visited-locations state)))])


    ))

(define (traverse-items items number-found)
  (cond
    [(empty? items) number-found]          ; Base case: empty list, return empty list
    [(pair? items)                         ; Recursive case: non-empty list
     (let* ([current-item (first items)]   ; Get the first item in the list
            [rest-of-items (rest items)]) ; Get the rest of the items in the list
       (if (not (item-visible current-item))           
           (begin
             (displayln "You found a @{(item-name current-item)}")
             (traverse-items rest-of-items (+ 1 number-found)))
           (traverse-items rest-of-items 0)))]))       
       
       



;;(define (remove-item-test item-name items)  )

;; Example usage:
(define backyard (location "Your backyard"
                           (string-append
                            "Your backyard is in disrepair, and much smaller than you would like. "
                            "The grass hasn't been growing well, and has basically turned into "
                            "a large mud pit.")
                           "Your disheveled backyard is as depressing as ever."
                           (list left-shoe)))
(define sideyard (location "Your sideyard"
                           (string-append
                            "Your sideyard hasn't been mowed in a long time, and is littered "
                            "with glass from broken bottles partygoers were throwing over here. "
                            "Wouldn't be surprising if some wildlife was in there somewere"
                            "It looks too dangerous to search here without shoes and gloves.")
                           "This overgrown area is dangerous without shoes and gloves."
                           (list house-key)))
(define frontyard (location "Your frontyard"
                            (string-append
                             "A lot of tire tracks have damaged your front yard. "
                             "It seems like a lot of people were doing donuts out there. "
                             "One of your trees has a copious amount of toilet paper in it. "
                             "Your front door is locked!")
                            "Your front yard is trashed, and you're still locked out."
                            (list right-shoe)))
(define deck (location "Your deck"
                       (string-append
                        "A wooden deck on the back of your house. "
                        "Compared to the rest of your property, it's "
                        "actually in pretty good shape. "
                        "Unfortunately the sliding door is barred shut. "
                        "It will be impossible to enter this way.")
                       "Your deck is well kept, but is not an entrance inside."
                       (list work-gloves)))

(define initial-inventory (inventory '()))

(define initial-state (game-state deck initial-inventory 0 '()))

(define (display-items items)
  (for-each (lambda (item) (displayln (item-name item))) items)
  (newline))

(define (display-visible-items items)
  (let ([visible-items (get-visible-items items)])
    (if (empty? visible-items)
        (displayln "No items are immediately visible here")
        (begin
          (displayln "You can see the following items here: ")
          (for-each (lambda (item) (displayln (item-name item))) visible-items)))))

(define (display-location state behavior)
  (let ([current-location (game-state-current-location state)])
    (display "Current Location: ")
    (displayln (location-name current-location))
    (behavior current-location)
    (display-visible-items (location-items current-location))))

(define (display-variable-location state)
  (let ([current-location (game-state-current-location state)]
        [actions-taken (game-state-num-actions state)]
        [visited-locations (game-state-visited-locations state)])
    (cond
      [(string-in-list? (game-state-visited-locations state) (location-name current-location))
       (display-location
        state
        (lambda (loc)
          (displayln (location-short-description loc))))]
      [else
       (display-location
        state
        (lambda (loc)
          (displayln (location-description loc))))])))

(define (display-inventory state)
  (let ([items (inventory-items (game-state-inventory state))])
    (if (empty? items)
        (begin
          (displayln "You have nothing in your inventory!")
          (newline))        
        (begin
          (displayln "You have the following:")
          (display-items items)))))

(define (display-help state)
  (display-location
        state
        (lambda (loc)
          (displayln (location-description loc))))
  (display-inventory state))

(define (string-in-list? lst string-to-find)
  (not (false? (member string-to-find lst))))

(define (mark-location-visited state)
  (let ([name (location-name (game-state-current-location state))])
    (if (string-in-list? (game-state-visited-locations state) name)
        state
        (update-state
         (game-state-current-location state)
         (game-state-inventory state)
         (game-state-num-actions state)
         (cons name (game-state-visited-locations state))))))

(define (print-menu state)
(displayln
 (simple-table->string
  #:align '(left left)
  (list
   (list "1. Move to your front yard"
         "7. Describe @{(string-downcase (location-name (game-state-current-location state)))}")
   (list "2. Move to your side yard"
         "8. Search @{(string-downcase (location-name (game-state-current-location state)))}")
   (list "3. Move to your back yard"
         "9. View your inventory")
   (list "4. Move to your deck"
         "H. Help")
   (list "5. Pick up an item"
         "Q. Quit")
   (list "6. Drop an item"
         "")))))

(define (game-start)
  (displayln "Slowly you fade into conciousness, initially confused by your surroundings.")
  (displayln "It soon becomes clear that you are on the back deck of your house.")
  (displayln "Memories suddenly flood back of a house party the previous night.")
  (displayln "You must have passed out back here, and you feel extremely dehydrated!")
  (displayln "You need to get back inside quickly, and your keys are missing!")
  (newline)
  (game-loop initial-state)
  )

(define (game-loop state)
  (display-variable-location state)
  (newline)
  (displayln (get-health-status state))
  (displayln "Available actions:")
  (print-menu state)
  (newline)
  (display "Choose an action: ")
  (let ([visited-state (mark-location-visited state)])
      (define choice (read-line))
  (newline)
  
  (cond
    [(equal? choice "1")
     (game-loop (move-location frontyard visited-state))]

    [(equal? choice "2")
     (game-loop (move-location sideyard visited-state))]

    [(equal? choice "3")
     (game-loop (move-location backyard visited-state))]

    [(equal? choice "4")
     (game-loop (move-location deck visited-state))]

    [(equal? choice "5")
     (displayln "Enter the name of the item to pick up: ")
     (let* ([item-name (read-line)]
            [updated-state (pick-up-item visited-state item-name)])
       (newline)
       (game-loop updated-state))]

    [(equal? choice "6")
     (displayln "Enter the name of the item you want to drop: ")
     (let* ([item-name (read-line)]
            [updated-state (drop-item visited-state item-name)])
       (newline)
       (game-loop updated-state))]

    [(equal? choice "7")
     (display-location
        visited-state
        (lambda (loc)
          (displayln (location-description loc))))
     (game-loop visited-state)]

    [(equal? choice "8")
     (displayln "Searching the current location:")
     (game-loop 
      (search-current-location visited-state))]

    [(equal? choice "9")
     (display-inventory visited-state)
     (game-loop visited-state)]

    [(string-ci=? choice "H")
     (display-help visited-state)
     (game-loop visited-state)]

    [(string-ci=? choice "Q")
     (displayln "Exiting the game. Goodbye!")
     ;; Optionally, you might want to perform any cleanup or save progress here
     (void)]
    
    [else
     (displayln "Invalid choice. Please choose a valid action.")
     (game-loop visited-state)]))
)

(game-start)