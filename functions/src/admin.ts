import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

export async function promoteToAdminIfWhitelisted(user: admin.auth.UserRecord, context: functions.EventContext) {
    const email = user.email
    // The only admin user allowed in the app
    const whitelistedAdminEmail = `admin@myshop.com`
    if (email === whitelistedAdminEmail) {
        if (user.customClaims && (user.customClaims as any).admin === true) {
            return {
                result: `${email} is already an admin`
            }
        }
        await admin.auth().setCustomUserClaims(user.uid, {
            admin: true
        })
        return {
            result: `Request fulfilled! ${email} is now an admin.`
        }    
    } else {
        return {
            result: `${email} is not whitelisted for admin rights`
        }
    }
}
