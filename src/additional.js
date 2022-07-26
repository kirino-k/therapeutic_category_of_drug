const root = env.root.children;

root.forEach(function (e1) {
  if (e1.children.length > 0) {
    let first = e1.values[0];
    e1.children.forEach(function (e2) {
      let second = e2.values[0];
      e2.children.forEach(function (e3) {
        let third = e3.values[0];
        e3.children.forEach(function (e4) {
          let fourth = e4.values[0];
          console.log(first + "," + second + "," + third + "," + fourth);
        });
      });
    });
  }
});
