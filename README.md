# Image Optimization API

## Setup

This project already contains a tiny Rails app, and you can run it like this:

```ssh
bundle install # Install dependencies
bundle exec rails server # Run server. please make sure it is bound on 127.0.0.1:3000 by checking log
```

Then, you can post an image and the server returns the same image with the one you sent.

`curl -X POST -F image=@path/to/image.jpg 'http://localhost:3000/optimizations' > response.jpg`

## Features

- Endpoint resize a passed image into specific size only when it is large
- Endpoint accept parameters to control the above optimization behavior
- Receive an image URL, download an image from the URL, and optimize it in the same manner as the above POST endpoint

For more details, see the following sections.

### 1. Endpoint resize a passed image into specific size only when it is large

- endpoint to resize an image into specific size.
- A responded image should have less than or equal to 200px of width and height
- The resizing process should keep an image's aspect ratio, and it should work as "fit", not "fill"
  - See: [What is the difference between fit and fill?](https://www.bannerbear.com/help/articles/26-difference-between-fit-and-fill/)
- The endpoint should resize an image only when an image's data size is more than 1MiB
  - If an image is larger than the threshold, return a resized image in WebP format
  - If an image is smaller than or equal to the threshold, return it without any modification like the first task

After implementing this, the behavior should look like this:

```ssh
curl -F image=@path/to/large-image.jpg 'http://localhost:3000/optimizations' > response1.webp
curl -F image=@path/to/small-image.jpg 'http://localhost:3000/optimizations' > response2.jpg
```

Then, `response1.webp` should be a resized WebP image, and `response2.jpg` should be the same as `small-image.jpg`.

### 2. Endpoint accept parameters to control the above optimization behavior

Modifying the above endpoint to accept parameters to control the optimization behavior.

For this task, we need to support 3 parameters: `width`, `height`, and `threshold`

- `width`: Specify maximum image width when resizing an image
  - Default value: 200px
  - Minimum value: 50px
  - Maximum value: 2000px
- `height`: Specify maximum image height when resizing an image
  - Default value: 200px
  - Minimum value: 50px
  - Maximum value: 2000px
- `threshold`: Specify a threshold data size to be used to decide whether we should resize an image or not
  - Default value: 1MiB
  - Minimum value: 100KiB
  - Maximum value: 100MiB

After implementing this, a client can control the image optimization behavior like:

``` curl -F image=@path/to/image.jpg 'http://localhost:3000/optimizations?width=100&height=150&threshold=204800' > response.webp ```

This means that the `image.jpg` will be resized to fit to 100px of width and 150px of height only when the image's data size is more than 200KiB.

### TODO: 3. Receive an image URL, download an image from the URL, and optimize it

GET endpoint that works the same as the above endpoint, but takes an image URL instead of an image binary data.

The endpoint should support the same parameters as the above endpoint except for the `image` parameter.

This means that we should be able to see an image with the following URL on a browser:

<http://localhost:3000/optimizations?url=https%3A%2F%2Fres.cloudinary.com%2Fcubki%2Fimage%2Fupload%2Ft_pc_standard%2Fv1664898811%2Fnnkuqcr5yfk5afacpm7n.jpg&width=100&height=150&threshold=204800>
