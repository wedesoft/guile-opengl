;;; figl
;;; Copyright (C) 2013 Andy Wingo <wingo@pobox.com>
;;; 
;;; Figl is free software: you can redistribute it and/or modify it
;;; under the terms of the GNU Lesser General Public License as
;;; published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version.
;;; 
;;; Figl is distributed in the hope that it will be useful, but WITHOUT
;;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General
;;; Public License for more details.
;;; 
;;; You should have received a copy of the GNU Lesser General Public
;;; License along with this program.  If not, see
;;; <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; figl is the Foreign Interface to GL.
;;
;;; Code:

(define-module (figl glut runtime)
  #:use-module (system foreign)
  #:use-module (figl runtime)
  #:use-module (figl gl runtime)
  #:export (define-glut-procedure define-glut-procedures))

(define libglut
  (delay (dynamic-link "libglut")))

(define (get-libglut)
  (force libglut))

(current-gl-get-dynamic-object get-libglut)

(define (resolve name)
  (dynamic-pointer (symbol->string name) (get-libglut)))

(define-syntax define-glut-procedure
  (syntax-rules (->)
    ((define-glut-procedure (name (pname ptype) ... -> type)
       docstring)
     (define-foreign-procedure (name (pname ptype) ... -> type)
       (resolve 'name)
       docstring))))

(define-syntax define-glut-procedures
  (syntax-rules ()
    ((define-glut-procedures ((name prototype ...) ...)
       docstring)
     (begin
       (define-glut-procedure (name prototype ...)
         docstring)
       ...))))