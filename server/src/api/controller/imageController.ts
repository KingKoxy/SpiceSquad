import express = require('express')
import AbstractController from "./abstractController";
import AuthenticatedRequest from '../middleware/authenticatedRequest'

export default class ImageController extends AbstractController {
    constructor() {
        super();
    }

    /**
     * @description 
     * @param image 
     * @returns 
     */
    public async createImage(image: Uint8Array): Promise<string> {
        const newImage = await this.prisma.image.create({
            data: {
                image: Buffer.from(image)
            }
        })
        return newImage.id
    }

    public fromIdtoURL(imageId: string): string {
        return process.env.URL + '/image/' + imageId
      }

    public fromURLtoId(imageURL: string): string {
        return imageURL.split('/').pop()
    }

    public async deleteImage(imageId: string): Promise<void> {
        await this.prisma.image.delete({
            where: {
                id: imageId
            }
        }).catch((error) => {
            throw(error)
        })
    }
    
    public async imageGet(req: express.Request< {id} , never, never>, res: express.Response, next: express.NextFunction): Promise<void> {
        try {
            const image = await this.prisma.image.findUnique({
                where: {
                    id: req.params.id
                }
            })
            if (image) {
                res.status(200).json(image)
            } else {
                res.status(404).json({
                    message: 'Image not found'
                })
            }
        } catch (error) {
            next(error)
        }
    }

    public async imagePost(req: AuthenticatedRequest<never , never, {image: Uint8Array}>, res: express.Response, next: express.NextFunction): Promise<void> {
        try {
            const imageURL = this.fromIdtoURL(await this.createImage(req.body.image))
            res.status(201).json({
                id: imageURL
            })
        } catch (error) {
            next(error)
        }
    }

    public async imagePatch(req: AuthenticatedRequest<{id}, never, {image: Uint8Array}>, res: express.Response, next: express.NextFunction): Promise<void> {
        try {
            const imageId = this.fromURLtoId(req.params.id)
            await this.prisma.image.update({
                where: {
                    id: imageId
                },
                data: {
                    image: Buffer.from(req.body.image)
                }
            })
            res.status(200).json({
                message: 'Image updated successfully!'
            })
        } catch (error) {
            next(error)
        }
    }
}