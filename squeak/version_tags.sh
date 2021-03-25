squeak::latest_release_before() {
  if [ "$1" -ge "19438" ]; then
    echo "Trunk"
  elif [ "$1" -ge "19438" ]; then
    echo "5.3"
  elif [ "$1" -ge "18236" ]; then
    echo "5.2"
  elif [ "$1" -ge "16555" ]; then
    echo "5.1"
  elif [ "$1" -ge "15113" ]; then
    echo "5.0"
  elif [ "$1" -ge "15102" ]; then
    echo "4.6"
  elif [ "$1" -ge "13680" ]; then
    echo "4.5"
  else
    echo "<historic>"
    return 1
  fi
}
