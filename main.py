import tensorflow as tf
import os
import tensorflow_datasets as tfds
import tensorflow_addons as tfa
import math
from tensorflow.keras import layers
from tensorflow import keras

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

# physical_devices = tf.config.list_physical_devices("GPU")
# tf.config.experimental.set_memory_growth(physical_devices[0], True)

(ds_train, ds_test), ds_info = tfds.load(
    "mnist",
    split=["train", "test"],
    shuffle_files=False,
    as_supervised=True,
    with_info=True,
)


@tf.function
def normalize_img(image, label):
    return tf.cast(image, tf.float32) / 255.0, label


@tf.function
def rotate(image, max_degrees=25):
    degrees = tf.random.uniform(
        [], -max_degrees, max_degrees, dtype=tf.float32)
    image = tfa.image.rotate(image, degrees * math.pi /
                             180, interpolation="BILINEAR")
    return image


@tf.function
def augment(image, label):
    image = tf.image.resize(image, size=[28, 28])

    # coloring of the image
    image = rotate(image)
    image = tf.image.random_brightness(image, max_delta=0.2)
    image = tf.image.random_contrast(image, lower=0.5, upper=1.5)
    return image, label


AUTOTUNE = tf.data.experimental.AUTOTUNE
BATCH_SIZE = 32

ds_train = ds_train.cache()
ds_train = ds_train.shuffle(ds_info.splits["train"].num_examples)
ds_train = ds_train.map(normalize_img, num_parallel_calls=AUTOTUNE)
ds_train = ds_train.map(augment, num_parallel_calls=AUTOTUNE)
ds_train = ds_train.batch(BATCH_SIZE)
ds_train = ds_train.prefetch(AUTOTUNE)

ds_test = ds_test.map(normalize_img, num_parallel_calls=AUTOTUNE)
ds_test = ds_test.batch(BATCH_SIZE)
ds_test = ds_test.prefetch(AUTOTUNE)


def my_model():
    inputs = keras.Input(shape=(28, 28, 1))
    x = layers.Conv2D(32, 3)(inputs)
    x = layers.BatchNormalization()(x)
    x = keras.activations.relu(x)
    x = layers.MaxPool2D()(x)
    x = layers.Conv2D(64, 3)(inputs)
    x = layers.BatchNormalization()(x)
    x = keras.activations.relu(x)
    x = layers.MaxPool2D()(x)
    x = layers.Conv2D(128, 3)(inputs)
    x = layers.BatchNormalization()(x)
    x = keras.activations.relu(x)
    x = layers.Flatten()(x)
    x = layers.Dense(64, activation="relu")(x)
    outputs = layers.Dense(10, activation="softmax")(x)
    return keras.Model(inputs=inputs, outputs=outputs)


model = my_model()
model.compile(
    loss=keras.losses.SparseCategoricalCrossentropy(from_logits=False),
    optimizer=keras.optimizers.Adam(lr=1e-4),
    metrics=["accuracy"],
)
model.fit(ds_train, epochs=20, verbose=2)
model.evaluate(ds_test)
model.save("model")
