import axios from 'axios'
import dotenv from 'dotenv'
dotenv.config()
console.log(process.env.NEXT_PUBLIC_API_URL)

async function getStatus() {
  try {
    const response = await axios.get(
      `${process.env.NEXT_PUBLIC_API_URL}/whatsapp/status`
    )

    return response.data
  } catch (error) {
    console.error('Erro ao buscar qrcode:', error)
  }
}

export default getStatus
