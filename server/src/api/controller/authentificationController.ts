import express = require("express");
import AbstractController from "./abstractController";
import firebaseAuth = require("firebase/auth");
import firebase = require("firebase/app");
import firebaseAdmin = require("firebase-admin");

class AuthentificationController extends AbstractController {
  constructor() {
    super();
  }

  public async userLogin(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    firebaseAuth
      .signInWithEmailAndPassword(this.auth, req.body.email, req.body.password)
      .then(async (userCredentials) => {
        console.log("Successfully logged in:", userCredentials.user);
        res.status(200).json({
          refreshToken: userCredentials.user.refreshToken,
          idToken: await firebaseAuth.getIdToken(userCredentials.user),
        });
      })
      .catch((error) => {
        switch (error.code) {
          case "auth/invalid-email":
            res.status(409).json({
              error: "The email address is not valid.",
            });
            break;
          case "auth/user-disabled":
            res.status(409).json({
              error:
                "The user corresponding to the given email has been disabled.",
            });
            break;
          case "auth/user-not-found":
            res.status(409).json({
              error: "There is no user corresponding to the given email.",
            });
            break;
          case "auth/wrong-password":
            res.status(409).json({
              error: "The password is invalid for the given email.",
            });
            break;
          default:
            res.status(409).json({
              error: "An error occurred.",
            });
            break;
        }
      });
  }

  public async userRegister(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    firebaseAuth
      .createUserWithEmailAndPassword(
        this.auth,
        req.body.email,
        req.body.password
      )
      .then(async (userCredentials) => {
        console.log("Successfully created new user:", userCredentials.user);
        await this.prisma.user.create({
          data: {
            user_name: req.body.user_name,
            email: req.body.email,
            firebase_user_id: userCredentials.user.uid,
            created_groups: 0,
          },
        });
        res.status(200).json({
          refreshToken: userCredentials.user.refreshToken,
          idToken: await firebaseAuth.getIdToken(userCredentials.user),
        });
      })
      .catch((error) => {
        switch (error.code) {
          case "auth/email-already-in-use":
            res.status(409).json({
              error: "The email address is already in use",
            });
            break;
          case "auth/invalid-email":
            res.status(200).json({
              error: "The email address is not valid.",
            });
            break;
          case "auth/operation-not-allowed":
            res.status(200).json({
              error: "The operation is not allowed.",
            });
            break;
          case "auth/weak-password":
            res.status(200).json({
              error: "The password is not strong enough.",
            });
            break;
          default:
            res.status(200).json({
              error: "An error occurred.",
            });
            break;
        }
      });
  }

  public userResetPassword(req: express.Request, res: express.Response) {
    firebaseAuth
      .sendPasswordResetEmail(this.auth, req.body.email)
      .then(() => {
        res.status(200).json({
          message: "Reset email sent successfully.",
        });
      })
      .catch((error) => {
        switch (error.code) {
          case "auth/invalid-email":
            res.status(200).json({
              error: "The email address is not valid.",
            });
            break;
          default:
            res.status(200).json({
              error: "An unknown error occurred.",
              "error message": error,
            });
            break;
        }
      });
  }

  public async getUserByToken(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    firebaseAuth
      .signInWithCredential(this.auth, req.body.refreshToken)
      .then(async (userCredentials) => {
        console.log("Successfully logged in:", userCredentials.user);
        res.status(200).json({
          idToken: await firebaseAuth.getIdToken(userCredentials.user),
          // TODO: Add user data
        });
      });
  }

  public async userRefreshToken(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    this.auth
      .updateCurrentUser(this.auth.currentUser)
      .then(async (token) => {
        console.log("Successfully logged in:", token);
        res.status(200).json({
          idToken: token,
        });
      })
      .catch((error) => {
        res.status(402).json({
          error: "An error occurred.",
          "error message": error,
        });
      });
  }

  public async userLogout(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    firebaseAuth.signOut(this.auth).then(() => {
      res.status(200).json({
        message: "Successfully logged out",
      });
    });
  }
}

export default AuthentificationController;
