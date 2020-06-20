(IN-PACKAGE "ACL2")

(DEFUN MEM (X Y)
  (IF (MEMBER X Y) T NIL))

(DEFUN DEL (X Y)
    (IF (CONSP Y)
        (IF (EQUAL X (CAR Y))
            (CDR Y)
            (CONS (CAR Y) (DEL X (CDR Y))))
        Y))

(DEFUN PERM (X Y)
    (IF (CONSP X)
        (AND (MEM (CAR X) Y)
             (PERM (CDR X) (DEL (CAR X) Y)))
        (NOT (CONSP Y))))
