import express = require('express')
import AbstractController from "./abstractController";

export default class ImageController extends AbstractController {
    constructor() {
        super();
    }

    public async createImage(image: Uint8Array): Promise<string> {
        const newImage = await this.prisma.image.create({
            data: {
                image: Buffer.from(image)
            }
        })
        return newImage.id
    }

    public async checkImageParamType(image: Uint8Array | string): Promise<string> {
        if (typeof image === 'string' && image.length === 0){
            console.log('No image provided')
            return null
        } else if (typeof image === 'string') {
            console.log('Image is a string')
          return image.split('/').pop() || '';
        } else if (typeof image === 'object') {
            console.log('Image is a Uint8Array')
            const newImage = await this.createImage(image)
            return newImage
        }
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
}