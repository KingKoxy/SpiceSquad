import express = require('express')
import AbstractController from './abstractController'
import AuthenticatedRequest from '../middleware/authenticatedRequest'

export default class ImageController extends AbstractController {
  
   /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   */
  constructor() {
    super()
  }

  /**
   * @description This function creates a new image.
   * @param image Uint8Array containing the image
   * @returns Promise<void>
   */
  public async createImage(image: Uint8Array): Promise<string> {
    const newImage = await this.prisma.image.create({
      data: {
        image: Buffer.from(image),
      },
    })
    return newImage.id
  }

  /**
   * @description This function converts an image id to an image url.
   * @param imageId string containing the image id
   * @returns string containing the image url
   */
  public fromIdtoURL(imageId: string): string {
    return process.env.URL + '/image/' + imageId
  }

  /**
   * @description This function converts an image url to an image id.
   * @param imageURL string containing the image url
   * @returns string containing the image
   * @throws Error if the image url is invalid
   */
  public fromURLtoId(imageURL: string): string {
    return imageURL.split('/').pop()
  }

  /**
   * @description This function deletes an image.
   * @param imageId string containing the image id
   * @returns Promise<void>
   * @throws Error if the image id is invalid
   */
  public async deleteImage(imageId: string): Promise<void> {
    await this.prisma.image
      .delete({
        where: {
          id: imageId,
        },
      })
      .catch((error) => {
        throw error
      })
  }

  /**
   * @description This function gets an image.
   * @param req: AuthenticatedRequest<{ imageId: string }, never, never> containing the image id
   * @param res: express.Response containing the image
   * @param next: express.NextFunction (for error handling)
   * @returns Promise<void>
   * @throws Error if the image id is invalid
   */
  public async imageGet(
    req: AuthenticatedRequest<{ imageId: string }, never, never>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    try {
      const image = await this.prisma.image.findUnique({
        where: {
          id: req.params.imageId,
        },
      })
      if (image) {
        // send file
        res.status(200).send(image.image)
      } else {
        res.status(404).json({
          message: 'Image not found',
        })
      }
    } catch (error) {
      next(error)
    }
  }

  /**
   * @description This function creates a new image.
   * @param req: AuthenticatedRequest<never, never, { image: Uint8Array }> containing the image
   * @param res: express.Response containing the image id
   * @param next: express.NextFunction (for error handling)
   * @returns Promise<void>
   * @throws Error if the image id is invalid
   */
  public async imagePost(
    req: AuthenticatedRequest<never, never, { image: Uint8Array }>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    try {
      const imageURL = this.fromIdtoURL(await this.createImage(req.body.image))
      res.status(201).json({
        id: imageURL,
      })
    } catch (error) {
      next(error)
    }
  }

  /**
   * @description This function updates an image.
   * @param req: AuthenticatedRequest<{ imageId: string }, never, { image: Uint8Array }> containing the image id and the image
   * @param res: express.Response containing the image id
   * @param next: express.NextFunction (for error handling)
   * @returns Promise<void>
   * @throws Error if the image id is invalid
   */
  public async imagePatch(
    req: AuthenticatedRequest<{ imageId: string }, never, { image: Uint8Array }>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    try {
      const imageId = this.fromURLtoId(req.params.imageId)
      await this.prisma.image
        .update({
          where: {
            id: imageId,
          },
          data: {
            image: Buffer.from(req.body.image),
          },
        })
        .catch((error) => {
          req.statusCode = 400
          next(error)
        })
      res.status(200).json({
        message: 'Image updated successfully!',
      })
    } catch (error) {
      next(error)
    }
  }
}
