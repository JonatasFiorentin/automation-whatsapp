import axios from 'axios'
import dotenv from 'dotenv'
dotenv.config()

async function whatsappLogout() {
  try {
    const response = await axios.post(
      `${process.env.NEXT_PUBLIC_API_URL}/whatsapp/logout`
    )

    return response.data
  } catch (error) {
    console.error('Erro ao buscar qrcode:', error)
  }
}

export default whatsappLogout
