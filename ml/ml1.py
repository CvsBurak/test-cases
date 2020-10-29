import pandas as pd
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow import keras
import numpy as np
from tensorflow.keras import layers
from tensorflow.keras.layers.experimental.preprocessing import Normalization
from tensorflow.keras.layers.experimental.preprocessing import CategoryEncoding
from tensorflow.keras.layers.experimental.preprocessing import StringLookup


df = pd.read_csv(
    "/Users/cvsburak/Desktop/Python/.venv/term-deposit-marketing-2020.csv")

df.y.replace(to_replace=dict(yes=1, no=0), inplace=True)

val_df = df.sample(frac=0.1)
train_df = df.drop(val_df.index)


def df_to_dataset(df):
    df = df.copy()
    label = df.pop('y')
    ds = tf.data.Dataset.from_tensor_slices((dict(df), label))
    ds = ds.shuffle(buffer_size=len(df))
    return ds


train_ds = df_to_dataset(train_df)
val_ds = df_to_dataset(val_df)

for x, y in train_ds.take(1):
    print("Input:", x)
    print("Target:", y)


train_ds = train_ds.batch(32)
val_ds = val_ds.batch(32)


def encode_numerical_feature(feature, name, dataset):
    normalizer = Normalization()

    feature_ds = dataset.map(lambda x, y: x[name])
    feature_ds = feature_ds.map(lambda x: tf.expand_dims(x, -1))

    normalizer.adapt(feature_ds)

    encoded_feature = normalizer(feature)
    return encoded_feature


def encode_string_categorical_feature(feature, name, dataset):
    index = StringLookup()

    feature_ds = dataset.map(lambda x, y: x[name])
    feature_ds = feature_ds.map(lambda x: tf.expand_dims(x, -1))

    index.adapt(feature_ds)

    encoded_feature = index(feature)
    encoder = CategoryEncoding(output_mode="binary")
    feature_ds = feature_ds.map(index)
    encoder.adapt(feature_ds)
    encoded_feature = encoder(encoded_feature)
    return encoded_feature


age = keras.Input(shape=(1,), name="age")
balance = keras.Input(shape=(1,), name="balance")
duration = keras.Input(shape=(1,), name="duration")
campaign = keras.Input(shape=(1,), name="campaign")
day = keras.Input(shape=(1,), name="day")

job = keras.Input(shape=(1,), name="job", dtype="string")
marital = keras.Input(shape=(1,), name="marital", dtype="string")
education = keras.Input(shape=(1,), name="education", dtype="string")
default = keras.Input(shape=(1,), name="default", dtype="string")
housing = keras.Input(shape=(1,), name="housing", dtype="string")
loan = keras.Input(shape=(1,), name="loan", dtype="string")
contact = keras.Input(shape=(1,), name="contact", dtype="string")
month = keras.Input(shape=(1,), name="month", dtype="string")


all_inputs = [age, balance, duration, campaign, job, marital,
              education, default, housing, loan, contact, day, month]


age_encoded = encode_numerical_feature(age, "age", train_ds)
balance_encoded = encode_numerical_feature(balance, "balance", train_ds)
duration_encoded = encode_numerical_feature(duration, "duration", train_ds)
campaign_encoded = encode_numerical_feature(campaign, "campaign",)
day_encoded = encode_numerical_feature(campaign, "day", train_ds)

job_encoded = encode_string_categorical_feature(job, "job", train_ds)
marital_encoded = encode_string_categorical_feature(
    marital, "marital", train_ds)
education_encoded = encode_string_categorical_feature(
    education, "education", train_ds)
default_encoded = encode_string_categorical_feature(
    default, "default", train_ds)
housing_encoded = encode_string_categorical_feature(
    housing, "housing", train_ds)
loan_encoded = encode_string_categorical_feature(loan, "loan", train_ds)
contact_encoded = encode_string_categorical_feature(
    contact, "contact", train_ds)
month_encoded = encode_string_categorical_feature(month, "month", train_ds)


all_features = layers.concatenate([
    age_encoded, balance_encoded, duration_encoded, campaign_encoded, job_encoded, marital_encoded, education_encoded,
    default_encoded, housing_encoded, loan_encoded, contact_encoded, day_encoded, month_encoded
])


x = layers.Dense(32, activation="relu")(all_features)
x = layers.Dropout(0.5)(x)
output = layers.Dense(1, activation="sigmoid")(x)
model = keras.Model(all_inputs, output)
model.compile("adam", "binary_crossentropy", metrics=["accuracy"])

keras.utils.plot_model(model, show_shapes=True, rankdir="LR")
print(train_ds)
model.fit(train_ds, epochs=50, validation_data=val_ds)


sample = {
    "age": 20,
    "balance": 14000,
    "duration": 300,
    "campaign": 2,
    "job": "management",
    "marital": "single",
    "education": "secondary",
    "default": "yes",
    "housing": "no",
    "loan": "no",
    "contact": "telephone",
    "day": 15,
    "month": "july",
}

input_dict = {name: tf.convert_to_tensor(
    [value]) for name, value in sample.items()}
predictions = model.predict(input_dict)


print((100 * predictions[0][0]))
