(defun UpdateList (key lst)

  ;; This function updates the list_box associated with the specified key
  ;; using the contents of the supplied lst

  (start_list key)
  (mapcar 'add_list lst)
  (end_list)
)
