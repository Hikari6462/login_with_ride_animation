# 🐻 Interactive Login Screen with Rive

**Subject:** [Insert Subject Name Here]  
**Professor:** [Insert Professor's Name Here]  

This repository contains a Flutter login application that features an interactive animated character using Rive. 

## ✨ Features
* **Interactive Avatar:** An animated bear that reacts to the user's input.
* **Email Tracking:** The character visually tracks the length of the text while typing in the email field.
* **Password Privacy:** The character covers its eyes when the password field is focused.
* **Visibility Toggle:** If the user toggles the password visibility to "show", the character uncovers its eyes to peek.

## 🛠️ Technologies Used
* **Flutter** 💙: UI toolkit for building natively compiled applications.
* **Dart** 🎯: Programming language optimized for UI.
* **Rive** 🎨: Real-time interactive design and animation tool.

## 🧠 What is Rive and a State Machine?
**Rive** is a powerful animation tool that allows designers and developers to create interactive, real-time animations that run smoothly across different platforms. 

A **State Machine** in Rive is a visual way to build interactive logic for animations. Instead of writing complex code to transition between different animation states (like "idle", "looking", or "hands up"), the State Machine handles these transitions based on specific inputs (Booleans, Numbers, or Triggers). In this project, we use a State Machine called `Login Machine` to easily trigger the bear's reactions based on the `FocusNode` of our text fields.

## 📂 Basic Project Structure
The core logic of this project is located within the `lib/` directory:

```text
lib/
 ├── main.dart         # Entry point of the application
 └── login_screen.dart # Contains the UI layout and the Rive State Machine controller logic
```


## feat(rive): animation added
[this my first animation in fluttler](https://github.com/Hikari6462/login_with_ride_animation/commit/eb50b004d1ec147301b13285abdee0cf389b16bf)
  <p align="center">  
<img src="https://github.com/Hikari6462/Luna-s-Nightmare-Mask/blob/main/artwork/firstanimation.png"
width="600"></center>  
</p>  

##🎥 Demo
![App Demo]([Insert Link to your GIF here])

##🏆 Credits
Animation created by: [Insert Creator's Name Here]([Insert Link to Creator's profile or original Rive file here])
