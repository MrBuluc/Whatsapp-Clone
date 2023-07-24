function forEachLoop(memberId) {
  console.log("value: " + memberId);
}

[1, 2, 3, 4, 5, 6, 7, 8, 9].filter((value) => value % 2 == 0).map(forEachLoop);
