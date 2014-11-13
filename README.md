Create thumbnail
==================

###Install###
    npm install bluezip/thumbnail --save
    
    
### Example ###

~~~javascript
  var Thumbnail     = require('bluezip-thumbnail');
  var data, thumbnail;

  data = {
    source: path.join('asserts', 'source', 'home_image.jpg'),
    destination: path.join('asserts', 'destination'),
    thumbnails: [
      {
        name: 'xxxx.jpeg',
        resize: false
      }
    ]
  };

  thumbnail = new Thumbnail(data);

  thumbnail.run(function(err) {
    console.log(err);
  });
~~~

#### 0.1.0 ####

1. Resize image with thumbnail 
2. Resize image with auto width or height
