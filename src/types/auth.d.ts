
export interface Resident {
  id: number
  first_name: string
  last_name: string
  chaya: string
  tel: string
}
export interface AdministerRequestBody {
  username: string
  password: string
  resdident_id? : number
}